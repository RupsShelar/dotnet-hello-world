# Stage 1 — Build
FROM mcr.microsoft.com/dotnet/sdk:2.1 AS build

WORKDIR /app
COPY . .

RUN dotnet restore ./hello-world-api/hello-world-api.csproj
RUN dotnet publish ./hello-world-api/hello-world-api.csproj -c Release -o out

# Stage 2 — Runtime
FROM mcr.microsoft.com/dotnet/runtime:2.1

WORKDIR /app
COPY --from=build /app/hello-world-api/out .

ENTRYPOINT ["dotnet", "hello-world-api.dll"]
