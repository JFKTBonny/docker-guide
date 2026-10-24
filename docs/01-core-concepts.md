# 1. Core Concepts

| Term | What it is |
|------|------------|
| **Image** | A read-only template containing your app and its dependencies. Built from a Dockerfile. |
| **Container** | A running instance of an image. |
| **Dockerfile** | A recipe file that tells Docker how to build an image. |
| **Registry** | Where images are stored and shared. Docker Hub is the default. |
| **Volume** | Persistent storage that survives container removal. |
| **Network** | Lets containers talk to each other. |
| **Compose** | Defines and runs multi-container apps from one YAML file. |

## How they fit together

```
Dockerfile  --docker build-->  Image  --docker run-->  Container
                                 |
                          docker push / pull
                                 |
                              Registry
```

## Verify your installation

```bash
docker --version
docker compose version
docker run hello-world
```

---

Next: [Images and Containers](02-images-and-containers.md)
