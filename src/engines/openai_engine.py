import os
from typing import Tuple, Dict, Any
from dotenv import load_dotenv, find_dotenv
from openai import OpenAI

# Cargar .env (buscando hacia arriba si no está en el cwd)
load_dotenv(find_dotenv())

_api_key = (
    os.getenv("OPENAI_API_KEY")
    or os.getenv("OPENAI_API_KEY_SK")
    or os.getenv("OPENAI_KEY")
    or os.getenv("OPENAI_TOKEN")
)

if not _api_key:
    # Permitimos que falle en tiempo de llamada, pero dejamos un mensaje claro en logs
    print("⚠️  OPENAI_API_KEY no encontrado en entorno (.env). Define OPENAI_API_KEY u OPENAI_API_KEY_SK.")

# Inicializar cliente con API Key explícita (si no, OpenAI intentará leer del entorno igualmente)
client = OpenAI(api_key=_api_key)

def fetch_openai_response(prompt: str, model: str = "gpt-4o-mini") -> Tuple[str, Dict[str, Any]]:
    """
    Realiza una llamada a la API de OpenAI y devuelve la respuesta y metadatos.
    """
    try:
        completion = client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": "You are a helpful assistant providing comprehensive and neutral information."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.5,
        )

        response_text = completion.choices[0].message.content or ""
        
        # Recolectar metadatos de uso y coste
        usage = completion.usage
        input_tokens = usage.prompt_tokens if usage else 0
        output_tokens = usage.completion_tokens if usage else 0
        
        # Precios aproximados para gpt-4o-mini (en USD por 1M de tokens)
        price_per_million_input = 0.15
        price_per_million_output = 0.60
        
        cost = ((input_tokens / 1_000_000) * price_per_million_input) + \
               ((output_tokens / 1_000_000) * price_per_million_output)

        metadata = {
            "model_name": model,
            "input_tokens": input_tokens,
            "output_tokens": output_tokens,
            "price_usd": cost
        }

        return response_text.strip(), metadata

    except Exception as e:
        print(f"Error en la llamada a OpenAI: {e}")
        return "", {"error": str(e)}