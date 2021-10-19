"""
this script is used to generate benchmarks of deep leanring model from torchvision.models module.
"""

import torch
from thop.profile import profile
from torchvision import models

model_names = sorted(
    name
    for name, obj in models.__dict__.items()
    if name.islower()
    and not name.startswith("__")  # and "inception" in name
    and callable(obj)
)

assert model_names, "no models found under torchvision.models"

print("found the following models from torchvision.models")
for name in model_names:
    print(f"{name}")

md_file = []
md_file.append("# Pytorch Models Evaluation Results\n")
md_file.append("Input |Model | Params(M) | GLOPs(G)")
md_file.append("---|---|---|---")

DEVICE = "cpu"
if torch.cuda.is_available():
    DEVICE = "cuda"

for name in model_names:
    model = models.__dict__[name]().to(DEVICE)
    dsize = (1, 3, 224, 224)
    if "inception" in name:
        dsize = (1, 3, 299, 299)
    inputs = torch.randn(dsize).to(DEVICE)
    total_ops, total_params = profile(model, (inputs,), verbose=False)

    md_file.append(
        f"{str(dsize)} |{name} | {total_params / (1000 ** 2):.2f} | {total_ops / (1000 ** 3):.2f}"
    )

md_file.append("")

with open("readme.md", "w+", encoding="utf-8") as file:
    file.write("\n".join(md_file))
