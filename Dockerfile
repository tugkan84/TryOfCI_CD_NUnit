FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-sac2016 AS base
WORKDIR /app
EXPOSE 3000

FROM microsoft/dotnet:2.1-sdk-nanoserver-sac2016 AS build
WORKDIR /src
COPY ["TryOfCI_CD_NUnit/TryOfCI_CD_NUnit.csproj", "TryOfCI_CD_NUnit/"]
RUN dotnet restore "TryOfCI_CD_NUnit/TryOfCI_CD_NUnit.csproj"
COPY . .
WORKDIR "/src/TryOfCI_CD_NUnit"
RUN dotnet build "TryOfCI_CD_NUnit.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TryOfCI_CD_NUnit.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TryOfCI_CD_NUnit.dll"]
