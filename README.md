# 🎓 Flutter Acadêmico - Portal do Aluno

Este é um aplicativo Flutter desenvolvido para fins acadêmicos. Ele simula um **portal de aluno**, com funcionalidades de visualização de boletim, rematrícula online e disciplinas rematriculadas. Os dados são consumidos da API [MockAPI.io](https://mockapi.io).

---

## 🚀 Funcionalidades

- Login simples (sem autenticação real)
- Dashboard com navegação entre telas
- 📊 Visualizar boletim com nota, frequência e status
- 📘 Selecionar disciplinas pendentes para rematrícula
- ✅ Confirmar rematrícula e visualizá-las em tela separada
- API REST simulada com MockAPI

---

## 📱 Telas do Aplicativo

- Login
- Dashboard
- Boletim
- Rematrícula Online
- Disciplinas Rematriculadas

---

## 📁 Estrutura de Diretórios

lib/
├── main.dart
├── models/
│ └── disciplina.dart
├── screens/
│ ├── login_screen.dart
│ ├── dashboard_screen.dart
│ ├── boletim_screen.dart
│ ├── rematricula_screen.dart
│ └── rematriculadas_screen.dart
├── services/
│ └── disciplina_service.dart

---

## Tecnologias
Flutter 3.x

HTTP (para chamadas REST)

MockAPI (dados simulados)