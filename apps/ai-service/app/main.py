from fastapi import FastAPI

app = FastAPI(title="OWNIT AI Service")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
