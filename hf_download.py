import os
import glob
from huggingface_hub import snapshot_download

# Rerieve huggin face repo id and model name pattern (without extension)
model_pattern = f'*{os.environ["HF_MODEL"]}'
repo_id = f'{os.environ["HF_REPO_ID"]}'
user_home = f'{os.environ["HOME"]}'
local_repo_path = os.path.join(f'{user_home}/models', repo_id)

# Download if file does not exist
models_found = glob.glob(f"{local_repo_path}/{model_pattern}")
if not models_found:
    snapshot_download(
        repo_id = repo_id,
        local_dir = local_repo_path,
        allow_patterns = [model_pattern],
    )
else:
    print(f'\nFound model: {models_found[0]}\n')
