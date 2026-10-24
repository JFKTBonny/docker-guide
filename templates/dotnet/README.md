# .NET (ASP.NET Core 8)

Builds with the .NET SDK, then runs on the smaller ASP.NET runtime image.

## Requirements

- One `.csproj` file in the project root
- .NET 8 (for .NET 9, change both image tags to `9.0`)

## Before building

In the Dockerfile, replace `MyApp.dll` with your project name
(the `.csproj` file name, with `.dll` instead of `.csproj`).

## Usage

Copy `Dockerfile` and `.dockerignore` into your project root, then:

```bash
docker build -t dotnet-app .
docker run -d --name dotnet-app -p 8080:8080 dotnet-app
```

Open http://localhost:8080

.NET 8 images listen on port **8080** by default (not 80).
