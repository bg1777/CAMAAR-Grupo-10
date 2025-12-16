# Wiki CAMAAR - Plataforma de Avaliação de Cursos

OBS: md da sprint 3 está no projeto! O nome do arquivo é "Grupo 10 - Sprint 3 ESW.md"

---

## Informações do Projeto

| Item | Descrição |
|------|-----------| 
| **Nome do Projeto** | CAMAAR - Plataforma de Avaliação de Cursos |
| **Disciplina** | Engenharia de Software |
| **Período** | 2025.2 |
| **Integrantes do Grupo** | Bernardo Gomes Rodrigues - 231034190 <br> Isaac Silva - 231025216 <br> Filipe Abadia Marcelino - 190087161 <br> Maria Carolina Burgum Abreu Jorge - 231013547 |

---

## Papéis Scrum

| Papel | Responsável | Matrícula |
|-------|-------------|-----------| 
| **Scrum Master** | Bernardo Gomes Rodrigues | 231034190 |
| **Product Owner** | Maria Carolina Burgum Abreu Jorge | 231013547 |

---

## Escopo do Projeto

### Descrição Geral

O CAMAAR é uma **plataforma web para avaliação de cursos e disciplinas** que integra dados do SIGAA (Sistema Integrado de Gestão de Atividades Acadêmicas) através de importação de arquivos JSON. O sistema permite que administradores criem formulários de avaliação reutilizáveis via templates, que são respondidos por usuários (alunos e professores). Os resultados são visualizados e gerenciados diretamente na plataforma.

### Objetivos Principais

- Facilitar a importação e sincronização de dados de turmas, disciplinas e participantes do SIGAA
- Permitir a criação e gestão de templates de formulários reutilizáveis
- Automatizar o processo de coleta de feedback sobre disciplinas e infraestrutura
- Viabilizar a análise de resultados de avaliações através de relatórios interativos
- Gerenciar usuários com autenticação simples e segura

### Stakeholders

- **Coordenadores de Curso (Administradores)**: Importam dados, criam templates e formulários, visualizam relatórios
- **Usuários (Alunos e Professores)**: Fazem login e respondem formulários de avaliação quando solicitado
- **Sistema SIGAA**: Fornecedor de dados de turmas, disciplinas e participantes via arquivos JSON

---

## Funcionalidades e Regras de Negócio

### 1. Autenticação de Usuários (3 pontos)

**Funcionalidades:**
- Login com email ou matrícula + senha
- Acesso diferenciado por perfil de usuário (usuário ou administrador)

**Regras de Negócio:**
- Credenciais válidas são necessárias para acessar o sistema
- Cada perfil tem acesso a funcionalidades específicas
- Apenas usuários ativos podem fazer login
- Administrador tem acesso a todas as funcionalidades de gestão
- Usuário comum tem acesso apenas a responder formulários

**Responsável:** Bernardo Gomes Rodrigues

---

### 2. Definir Senha no Cadastro (2 pontos)

**Funcionalidades:**
- Usuários novos utilizam senha padrão no primeiro acesso
- Sistema oferece interface de login com email/matrícula

**Regras de Negócio:**
- Senha padrão é a matrícula do usuário
- A senha não pode ser alterada após o cadastro
- A mesma senha (matrícula) é sempre utilizada para login
- Usuário acessa com email ou matrícula + senha

**Responsável:** Bernardo Gomes Rodrigues

---

### 3. Importação de Dados do SIGAA (5 pontos)

**Funcionalidades:**
- Importar turmas, disciplinas e participantes do SIGAA a partir de arquivos JSON
- Carregamento automatizado de dados de estrutura acadêmica
- Criação automática de usuários baseada nos dados importados

**Regras de Negócio:**
- Importação deve ser realizada apenas por administradores
- Dados são parseados do formato JSON específico do SIGAA
- Novos usuários são criados automaticamente com senha padrão (matrícula)
- Duplicatas são ignoradas (validação por ID/matrícula única)
- Alunos e professores são diferenciados no banco de dados durante a importação
- Turmas são associadas aos seus respectivos professores

**Responsável:** Bernardo Gomes Rodrigues

---

### 4. Atualizar Base de Dados com Dados do SIGAA (3 pontos)

**Funcionalidades:**
- Sincronizar informações de turmas, disciplinas e participantes com novos dados do SIGAA
- Manter base de dados atualizada com mudanças acadêmicas

**Regras de Negócio:**
- Atualização deve ser realizada apenas por administradores
- Novos registros são adicionados à base de dados
- Registros existentes são atualizados com informações recentes
- Mudanças de alocação de alunos em turmas são sincronizadas

**Responsável:** Bernardo Gomes Rodrigues

---

### 5. Gestão de Usuários e Participantes (2 pontos)

**Funcionalidades:**
- Cadastro automático de participantes através da importação SIGAA
- Visualização de usuários cadastrados
- Desativação de usuários inativos

**Regras de Negócio:**
- Usuários são criados automaticamente durante importação
- Senha inicial é a matrícula do usuário (não alterável)
- Usuário inativo não pode fazer login
- Email é obrigatório e único por usuário
- Alunos e professores são classificados conforme dados do SIGAA

**Responsável:** Bernardo Gomes Rodrigues

---

### 6. Criação de Templates de Formulários (4 pontos)

**Funcionalidades:**
- Criar templates com múltiplos tipos de questões
- Visualizar templates criados
- Editar templates existentes
- Deletar templates

**Regras de Negócio:**
- Template deve ter no mínimo 1 questão
- Nome do template deve ser único
- Apenas o criador (administrador) do template pode editá-lo e deletá-lo
- Tipos de questões suportados: Múltipla escolha, Texto aberto, Verdadeiro/Falso
- Mudanças em template apenas afetam novos formulários criados

**Responsável:** Maria Carolina Burgum Abreu Jorge

---

### 7. Criação de Formulários de Avaliação (6 pontos)

**Funcionalidades:**
- Criar formulário baseado em template pré-existente
- Selecionar turmas para aplicar o formulário
- Visualizar formulários criados
- Gerenciar status dos formulários

**Regras de Negócio:**
- Formulário herda todas as questões do template no momento da criação
- Deve selecionar no mínimo 1 turma para aplicar o formulário
- Mesmo formulário não pode ser respondido 2 vezes pelo mesmo participante
- Apenas administradores podem criar formulários
- Formulários podem estar em rascunho ou ativos
- Formulários estarão disponíveis para todos os usuários das turmas selecionadas

**Responsável:** Isaac Silva

---

### 8. Visualização de Formulários Disponíveis (3 pontos)

**Funcionalidades:**
- Usuários visualizam formulários não respondidos das suas turmas
- Filtrar formulários por turma e disciplina
- Visualizar informações do formulário antes de responder

**Regras de Negócio:**
- Usuário visualiza apenas formulários de turmas onde está matriculado ou leciona
- Formulários já respondidos não aparecem na lista
- Informações do formulário incluem: nome, disciplina, turma, questões
- Sistema valida se usuário tem permissão de responder cada formulário

**Responsável:** Isaac Silva

---

### 9. Resposta de Formulários (5 pontos)

**Funcionalidades:**
- Responder questionários de avaliação
- Salvar respostas como rascunho
- Submeter respostas finais
- Editar respostas enquanto não submetidas
- Validação de campos obrigatórios

**Regras de Negócio:**
- Participante visualiza apenas formulários de turmas onde está matriculado ou leciona
- Todos os campos obrigatórios devem ser preenchidos antes de enviar
- Participante pode editar respostas enquanto formulário não foi submetido
- Uma vez submetido, formulário não pode ser alterado
- Resposta não pode ser submetida duas vezes pelo mesmo participante
- Sistema valida tipo de resposta conforme tipo de questão
- Respostas são armazenadas com timestamp de submissão

**Responsável:** Isaac Silva

---

### 10. Visualização de Resultados dos Formulários (5 pontos)

**Funcionalidades:**
- Administradores visualizam respostas de todos os formulários criados
- Filtrar resultados por formulário
- Visualizar respostas detalhadas de participantes
- Acompanhamento em tempo real do número de respondentes
- Análise das respostas direto na plataforma

**Regras de Negócio:**
- Apenas administrador pode acessar resultados
- Respostas são exibidas de forma organizada por formulário
- Informações exibidas incluem: participante, turma, data de resposta, respostas individuais
- Dados são apresentados através de interface web interativa
- Relatórios podem ser visualizados conforme respostas vão chegando
- Nomes de participantes podem ser anonimizados (apenas matrícula) conforme necessário

**Responsável:** Isaac Silva

---

## Atribuição de Histórias de Usuário

| # | História de Usuário | Funcionalidade | Pontos | Responsável |
|---|---------------------|-----------------|--------|-------------|
| 1 | Importar dados do SIGAA | Importação de Dados | 5 | Bernardo Gomes |
| 2 | Responder questionário sobre turma | Resposta de Formulários | 5 | Isaac Silva |
| 3 | Cadastrar participantes ao importar | Gestão de Usuários | 2 | Bernardo Gomes |
| 4 | Visualizar resultados no site | Visualização de Resultados | 5 | Isaac Silva |
| 5 | Criar template de formulário | Gerenciamento de Templates | 4 | Maria Carolina |
| 6 | Criar formulário baseado em template | Criação de Formulários | 6 | Maria Carolina |
| 7 | Acessar sistema com credenciais | Autenticação | 3 | Bernardo Gomes |
| 8 | Definir senha no cadastro | Definição de Senha | 2 | Bernardo Gomes |
| 9 | Atualizar base de dados existente | Atualização de Dados | 3 | Bernardo Gomes |
| 10 | Visualizar formulários não respondidos | Visualização de Formulários | 3 | Isaac Silva |
| 11 | Visualizar formulários criados | Criação de Formulários | 2 | Isaac Silva |
| 12 | Visualizar templates criados | Gerenciamento de Templates | 2 | Maria Carolina |
| 13 | Editar e deletar template | Gerenciamento de Templates | 2 | Maria Carolina |

**Total de Pontos: 40 pontos**

---

## Histórias de Usuário Detalhadas com Pontuação

### HU-01: Importar dados do SIGAA (5 pontos)

```
Como Administrador
Quero importar dados de turmas, disciplinas e participantes do SIGAA através de arquivos JSON
A fim de carregar a base de dados inicial do sistema com informações acadêmicas

Critérios de Aceitação:
- Sistema importa com sucesso turmas, disciplinas e participantes do SIGAA
- Dados duplicados são ignorados (validação por matrícula/ID único)
- Novos usuários são criados automaticamente com senha padrão (matrícula)
- Alunos e professores são diferenciados no banco de dados conforme dados importados
- Turmas são associadas aos professores responsáveis
- Mensagem de sucesso ou erro é exibida após importação
```

**Pontos:** 5 | **Responsável:** Bernardo Gomes Rodrigues

---

### HU-02: Responder questionário sobre turma (5 pontos)

```
Como Usuário (Aluno ou Professor)
Quero responder o questionário sobre a turma em que estou matriculado/leciono
A fim de submeter minha avaliação da turma e disciplina

Critérios de Aceitação:
- Visualiza questionário da turma com todas as questões
- Preenche questões obrigatórias antes de submeter
- Submete respostas finais e recebe confirmação
- Não pode responder 2 vezes o mesmo formulário
- Pode editar respostas enquanto não submeter
- Uma vez submetido, formulário se torna imutável
```

**Pontos:** 5 | **Responsável:** Isaac Silva

---

### HU-03: Cadastrar participantes ao importar (2 pontos)

```
Como Administrador
Quero cadastrar participantes de turmas do SIGAA ao importar dados
A fim de que eles possam acessar o sistema CAMAAR

Critérios de Aceitação:
- Novos usuários são criados automaticamente
- Senha inicial é a matrícula do usuário
- Usuário pode fazer login com email/matrícula e essa senha
- Usuários já existentes são associados às novas turmas
```

**Pontos:** 2 | **Responsável:** Bernardo Gomes Rodrigues

---

### HU-04: Visualizar resultados no site (5 pontos)

```
Como Administrador
Quero visualizar os resultados de um formulário direto na plataforma
A fim de avaliar o desempenho das turmas e analisar feedback

Critérios de Aceitação:
- Interface exibe todas as respostas de um formulário
- Informações incluem: participante, turma, data, respostas individuais
- Dados são apresentados de forma organizada e legível
- Pode filtrar por formulário específico
- Visualização funciona em tempo real conforme respostas chegam
```

**Pontos:** 5 | **Responsável:** Isaac Silva

---

### HU-05: Criar template de formulário (4 pontos)

```
Como Administrador
Quero criar um template de formulário contendo questões reutilizáveis
A fim de gerar formulários de avaliações de forma eficiente e consistente

Critérios de Aceitação:
- Template com nome único
- Mínimo 1 questão obrigatória
- Suporta múltiplos tipos: múltipla escolha, texto aberto, verdadeiro/falso
- Apenas criador pode editar e deletar
- Mudanças em template só afetam novos formulários
```

**Pontos:** 4 | **Responsável:** Maria Carolina Burgum Abreu Jorge

---

### HU-06: Criar formulário baseado em template (6 pontos)

```
Como Administrador
Quero criar um formulário baseado em um template para turmas específicas
A fim de coletar avaliações das disciplinas de forma organizada

Critérios de Aceitação:
- Seleciona template existente
- Escolhe múltiplas turmas (mínimo 1)
- Formulário herda questões do template
- Formulário fica disponível para todos os usuários das turmas selecionadas
```

**Pontos:** 6 | **Responsável:** Maria Carolina Burgum Abreu Jorge

---

### HU-07: Acessar sistema com credenciais (3 pontos)

```
Como Usuário do sistema
Quero acessar o sistema utilizando email/matrícula e senha
A fim de responder formulários ou gerenciar o sistema conforme meu perfil

Critérios de Aceitação:
- Login com email funciona
- Login com matrícula funciona
- Validação de credenciais funciona
- Redirecionamento para painel/dashboard após sucesso
- Mensagens de erro claras para credenciais inválidas
```

**Pontos:** 3 | **Responsável:** Bernardo Gomes Rodrigues

---

### HU-08: Definir senha no cadastro (2 pontos)

```
Como Usuário
Quero ter acesso ao sistema com uma senha definida
A fim de acessar o sistema com minhas credenciais de login

Critérios de Aceitação:
- Senha inicial é a matrícula do usuário
- Senha não pode ser alterada após o cadastro
- Usuário faz login com email/matrícula e a senha (matrícula)
- Mesma senha é sempre utilizada para futuros logins
```

**Pontos:** 2 | **Responsável:** Bernardo Gomes Rodrigues

---

### HU-09: Atualizar base de dados existente (3 pontos)

```
Como Administrador
Quero atualizar a base de dados com dados atuais do SIGAA
A fim de sincronizar mudanças acadêmicas (novas turmas, alunos, etc)

Critérios de Aceitação:
- Sincroniza dados existentes
- Adiciona novos dados
- Atualiza mudanças de turmas de alunos/professores
- Mensagem clara de conclusão ou erros
```

**Pontos:** 3 | **Responsável:** Bernardo Gomes Rodrigues

---

### HU-10: Visualizar formulários não respondidos (3 pontos)

```
Como Usuário (Aluno ou Professor)
Quero visualizar os formulários não respondidos das turmas em que estou matriculado/leciono
A fim de poder escolher qual irei responder

Critérios de Aceitação:
- Lista apenas formulários não respondidos
- Mostra turma, disciplina, informações relevantes
- Formulários respondidos não aparecem
- Sistema valida se usuário tem permissão de responder cada formulário
```

**Pontos:** 3 | **Responsável:** Isaac Silva

---

### HU-11: Visualizar formulários criados (2 pontos)

```
Como Administrador
Quero visualizar os formulários que criei
A fim de gerenciar e acompanhar o status das avaliações

Critérios de Aceitação:
- Lista todos os formulários criados
- Mostra nome, template, turmas, status, data
- Quantidade de respostas exibida
- Opção de visualizar detalhes e resultados
```

**Pontos:** 2 | **Responsável:** Isaac Silva

---

### HU-12: Visualizar templates criados (2 pontos)

```
Como Administrador
Quero visualizar os templates que criei
A fim de poder editar, deletar ou usar como base para novos formulários

Critérios de Aceitação:
- Lista todos os templates
- Mostra nome, quantidade de questões, data de criação
- Acesso aos detalhes do template
- Opções de editar e deletar
```

**Pontos:** 2 | **Responsável:** Maria Carolina Burgum Abreu Jorge

---

### HU-13: Editar e deletar templates (2 pontos)

```
Como Administrador
Quero editar e/ou deletar um template que criei
A fim de organizar e manter meus templates atualizados

Critérios de Aceitação:
- Pode editar questões de um template
- Confirmação de exclusão antes de deletar
- Apenas criador pode editar e excluir
- Mudanças em template não afetam formulários já criados
```

**Pontos:** 2 | **Responsável:** Maria Carolina Burgum Abreu Jorge

---

## Política de Branching

### Estratégia Git Flow

```
- main: Produção (releases e hotfixes)
- develop: Desenvolvimento principal
- feature/HU-XX-descricao: Novas funcionalidades
- bugfix/HU-XX-descricao: Correções de bugs
- hotfix/issue-descricao: Correções urgentes em produção
```

### Fluxo de Trabalho

1. **Iniciar Nova Funcionalidade:**
   - Criação de branch para a funcionalidade
   - Garantir que a nova branch está atualizada com as alterações da main

2. **Trabalhar na Funcionalidade:**
   - Commits descritivos em português
   - Formato: `HU-01: Descrição da alteração`
   - Exemplo: `HU-01: Implementar validação de duplicatas`

3. **Pull Request para Develop:**
   - Descrever as alterações
   - Referenciar a HU
   - Mínimo 1 aprovação antes de merge
   - Rodar testes antes de merge

### Convenção de Commits

```
<tipo>(<escopo>): <descrição>

<corpo>
```

**Tipos:**
- `feat`: Nova funcionalidade (HU)
- `fix`: Correção de bug
- `docs`: Documentação
- `style`: Formatação
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Tarefas de build/dependências

**Exemplo:**
```
feat(autenticacao): Implementar login com email e matrícula
```
---

## Estrutura de Dados JSON

### Arquivo classes.json (exemplo)

```json
[
    {
        "code": "CIC0097",
        "name": "BANCOS DE DADOS",
        "class": {
            "classCode": "TA",
            "semester": "2025.2",
            "time": "35T45"
        }
    },
    {
        "code": "CIC0105",
        "name": "ENGENHARIA DE SOFTWARE",
        "class": {
            "classCode": "TA",
            "semester": "2025.2",
            "time": "35M12"
        }
    }
]
```

### Arquivo class_members.json (exemplo)

```json
[
    {
        "code": "CIC0097",
        "classCode": "TA",
        "semester": "2025.2",
        "dicente": [
            {
                "nome": "Ana Clara Jordao Perna",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190084006",
                "usuario": "190084006",
                "email": "acjpjvjp@gmail.com"
            }
        ],
        "docente": {
            "nome": "MARISTELA TERTO DE HOLANDA",
            "matricula": "123456789",
            "usuario": "123456789",
            "email": "maristela@unb.br"
        }
    }
]
```

---

