#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Pet.Project.Payment.Gateway.Api/Pet.Project.Payment.Gateway.Api.csproj", "Pet.Project.Payment.Gateway.Api/"]
COPY ["Pet.Project.Payment.Gateway.Domain/Pet.Project.Payment.Gateway.Domain.csproj", "Pet.Project.Payment.Gateway.Domain/"]
COPY ["Pet.Project.Payment.Gateway.Infraestructure/Pet.Project.Payment.Gateway.Infraestructure.csproj", "Pet.Project.Payment.Gateway.Infraestructure/"]
RUN dotnet restore "Pet.Project.Payment.Gateway.Api/Pet.Project.Payment.Gateway.Api.csproj"
COPY . .
WORKDIR "/src/Pet.Project.Payment.Gateway.Api"
RUN dotnet build "Pet.Project.Payment.Gateway.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pet.Project.Payment.Gateway.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pet.Project.Payment.Gateway.Api.dll"]