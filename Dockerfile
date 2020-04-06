FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster-arm32v7 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# copy and publish app and libraries
COPY . ./
RUN dotnet restore && dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/runtime:3.1-buster-slim-arm32v7 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
ENV CONFIG_PATH=/config
ENTRYPOINT ["dotnet", "firefly-plaid-connector.dll"]
