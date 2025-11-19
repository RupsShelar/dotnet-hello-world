# Stage 1 — Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Copy everything
COPY . .

# Restore and build the project
RUN dotnet restore ./hello-world-api/hello-world-api.csproj
RUN dotnet publish ./hello-world-api/hello-world-api.csproj -c Release -o /app/publish

# Stage 2 — Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "hello-world-api.dll"]
