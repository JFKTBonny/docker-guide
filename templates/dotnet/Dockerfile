# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY *.csproj ./
RUN dotnet restore

COPY . .
RUN dotnet publish -c Release -o /app/publish --no-restore

# Run stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app

COPY --from=build /app/publish .

# Built-in non-root user in .NET 8 images
USER app

EXPOSE 8080

# Replace "MyApp.dll" with your project name
ENTRYPOINT ["dotnet", "MyApp.dll"]
