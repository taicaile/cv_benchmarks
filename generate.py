"""generate table"""
from dataclasses import dataclass
from typing import Iterable

from jinja2 import Environment, FileSystemLoader

env = Environment(loader=FileSystemLoader("templates"))
template = env.get_template("table.html")


@dataclass
class ModelDict:
    """Model Dict"""
    input: str
    name: str
    params: str
    glops: str


def render(models: Iterable[ModelDict], title: str):
    """generate index.html"""
    output = template.render(title=title, models=models)

    # to save the results
    with open("index.html", "w+", encoding="utf-8") as file:
        file.write(output)
