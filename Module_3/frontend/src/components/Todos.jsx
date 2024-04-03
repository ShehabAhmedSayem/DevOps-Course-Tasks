import React, { useEffect, useState } from "react";
import {
    Stack,
    Input,
    InputGroup
} from "@chakra-ui/react";

const TodosContext = React.createContext({
    todos: [], fetchTodos: () => {}
});

function AddTodo() {
    const [item, setItem] = React.useState("")
    const {todos, fetchTodos} = React.useContext(TodosContext)
  
    const handleInput = (event) => {
      setItem(event.target.value)
    }
    const handleSubmit = (event) => {
      event.preventDefault();
      const newTodo = {
        "id": todos.length + 1,
        "item": item
      }
  
      fetch("http://localhost:8080/api/todo", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(newTodo)
      }).then(fetchTodos)
    }
  
    return (
      <form onSubmit={handleSubmit}>
        <InputGroup size="md">
          <Input
            pr="4.5rem"
            type="text"
            placeholder="Add a todo item"
            aria-label="Add a todo item"
            onChange={handleInput}
          />
        </InputGroup>
      </form>
    )
  }

export default function Todos() {
  const [todos, setTodos] = useState([])
  const fetchTodos = async () => {
    const response = await fetch("http://localhost:8080/api/todo")
    const todos = await response.json()
    setTodos(todos.data)
  }
  useEffect(() => {
    fetchTodos()
  }, [])
  return (
    <TodosContext.Provider value={{todos, fetchTodos}}>
        <AddTodo />
        <Stack spacing={5}>
        {todos.map((todo) => (
            <li key={todo.id}>
                <b>{todo.item}</b>
            </li>
        ))}
        </Stack>
    </TodosContext.Provider>
  )
}
