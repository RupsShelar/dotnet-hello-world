# Stage 1 — Build the .NET app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy everything into container
COPY . .

# Publish the app
RUN dotnet publish -c Release -o out

# Stage 2 — Runtime container
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy published output
COPY --from=build /app/out .

# Run the app
ENTRYPOINT ["dotnet", "dotnet-hello-world.dll"]
