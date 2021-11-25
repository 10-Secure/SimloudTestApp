# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY MyTvTime/*.csproj ./MyTvTime/
RUN dotnet restore

# copy everything else and build app
COPY MyTvTime/. ./MyTvTime/
WORKDIR /source/MyTvTime
RUN dotnet publish -c release -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=build /app ./
EXPOSE 8080
EXPOSE 80
ENTRYPOINT ["dotnet", "MyTvTime.dll"]