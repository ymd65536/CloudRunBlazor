FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["CloudRunBlazor.csproj", "."]
RUN dotnet restore "CloudRunBlazor.csproj"
COPY . .
RUN dotnet build "CloudRunBlazor.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CloudRunBlazor.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CloudRunBlazor.dll"]
