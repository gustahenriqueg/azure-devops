# Sprint Automation Script

## 📌 Visão Geral
Este script automatiza a criação de sprints no Azure DevOps, permitindo que seja configurado dinamicamente via arquivos externos (`config.json`, `sprintData.json` e `pat.txt`).

## 🚀 Como Usar
1️⃣ **Edite** `config.json` para definir a organização, projeto e quantidade de sprints.  
2️⃣ **Ajuste** `sprintData.json` para definir de onde começar (última sprint e data).  
3️⃣ **Salve** seu token PAT em `pat.txt`.  
4️⃣ **Execute o script** no **PowerShell**:
   ```powershell
   .\SprintAutomation.ps1
   ```
5️⃣ O script **salvará a última sprint e data automaticamente**, para continuar corretamente na próxima execução.

---

## ✏️ Criar uma Sprint Manualmente
Se você **já possui sprints anteriores** e deseja começar de uma sprint específica, siga este exemplo:

- Digamos que deseja **criar a Sprint 30**, que começa em **21/07/2025** e termina em **25/07/2025**.  
- Edite `sprintData.json` para:
   ```json
   {
       "lastSprint": 30,
       "lastSprintDate": "2025-07-25"
   }
   ```
- Ajuste `config.json` para:
   ```json
   {
       "org": "https://dev.azure.com/minhaorganizacao/",
       "prj": "labs",
       "startSprintDate": "2025-07-21",
       "totalSprints": 1,
       "sprintDuration": 4
   }
   ```
- **Execute o script normalmente** para criar apenas a Sprint 30.  
- Para **outros casos**, siga este mesmo padrão, ajustando as datas conforme necessário.  

---

## 🛠️ Estrutura do Projeto
```
📂 SprintAutomation
 ├── SprintAutomation.ps1    # Script principal
 ├── config.json             # Configurações gerais
 ├── sprintData.json         # Última sprint criada e sua data
 ├── pat.txt                 # Token PAT do Azure DevOps
 ├── README.md               # Documentação do projeto
```

---

## 📄 Licença
Este projeto está disponível para uso interno. Ajuste conforme necessário. 😊

---
