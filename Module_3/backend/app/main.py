from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()

origins = ["*"]
todos = [{"id": "1", "item": "Read a book."}, {"id": "2", "item": "Cycle around town."}]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api", tags=["root"])
async def read_root() -> dict:
    return {"message": "Welcome to your todo list."}


@app.get("/api/todo", tags=["todos"])
async def get_todos() -> dict:
    return {"data": todos}


@app.post("/api/todo", tags=["todos"])
async def add_todo(todo: dict) -> dict:
    todos.append(todo)
    return {"data": {"Todo added."}}
