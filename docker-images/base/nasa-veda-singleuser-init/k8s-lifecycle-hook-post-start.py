import subprocess

try:
    result = subprocess.run(
        ["gitpuller", "https://github.com/NASA-IMPACT/veda-docs/", "main", "/home/jovyan/veda-doc-examples"],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True  # Capture output as a string instead of bytes
    )
    print(f"Command stdout:\n{result.stdout}")
    print(f"Command stderr:\n{result.stderr}")
except subprocess.CalledProcessError as e:
    print(f"Command failed with error {e.returncode}, stderr:\n{e.stderr}")
    raise
