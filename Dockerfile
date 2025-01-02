FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MultiRotorResearch.Api/MultiRotorResearch.Api.csproj", "MultiRotorResearch.Api/"]
COPY ["MultiRotorResearch.Application/MultiRotorResearch.Application.csproj", "MultiRotorResearch.Application/"]
COPY ["MultiRotorResearch.Domain/MultiRotorResearch.Domain.csproj", "MultiRotorResearch.Domain/"]
COPY ["MultiRotorResearch.Infrastructure/MultiRotorResearch.Infrastructure.csproj", "MultiRotorResearch.Infrastructure/"]
RUN dotnet restore "MultiRotorResearch.Api/MultiRotorResearch.Api.csproj"
COPY . .
WORKDIR "/src/MultiRotorResearch.Api"
RUN dotnet build "MultiRotorResearch.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MultiRotorResearch.Api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MultiRotorResearch.Api.dll"]
