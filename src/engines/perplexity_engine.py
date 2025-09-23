import os
import requests
import json
from typing import Tuple, Dict, Any

def fetch_perplexity_response(prompt: str, model: str = "llama-3-sonar-small-32k-online") -> Tuple[str, Dict[str, Any]]:
    """
    Realiza una llamada a la API de Perplexity y devuelve la respuesta y metadatos.
    """
    url = "https://api.perplexity.ai/chat/completions"
    
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": "You are a helpful assistant providing comprehensive and neutral information."},
            {"role": "user", "content": prompt}
        ]
    }
    
    headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "authorization": f"Bearer {os.getenv('PERPLEXITY_API_KEY')}"
    }
    
    try:
        response = requests.post(url, json=payload, headers=headers, timeout=30)
        response.raise_for_status() # Lanza un error si la petición falla
        
        data = response.json()
        response_text = data['choices'][0]['message']['content']
        
        # Recolectar metadatos de uso y coste
        usage = data.get('usage', {})
        input_tokens = usage.get('prompt_tokens', 0)
        output_tokens = usage.get('completion_tokens', 0)

        # Precios aproximados para llama-3-sonar-small-32k-online (en USD por 1M de tokens)
        price_per_million_input = 0.20
        price_per_million_output = 0.20
        
        cost = ((input_tokens / 1_000_000) * price_per_million_input) + \
               ((output_tokens / 1_000_000) * price_per_million_output)
               
        metadata = {
            "model_name": model,
            "input_tokens": input_tokens,
            "output_tokens": output_tokens,
            "price_usd": cost
        }
        
        return response_text.strip(), metadata

    except requests.exceptions.RequestException as e:
        err_msg = str(e)
        if e.response is not None:
            try:
                err_body = e.response.text
                err_msg = f"{e} | body={err_body}"
            except Exception:
                pass
        print(f"Error en la llamada a Perplexity: {err_msg}")
        return "", {"error": err_msg}
