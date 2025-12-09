# Wiki CAMAAR - Plataforma de Avaliação de Cursos

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

O CAMAAR é uma **plataforma web para avaliação de cursos e disciplinas** integrada com o SIGAA (Sistema Integrado de Gestão de Atividades Acadêmicas) por meio de arquivos JSON. O sistema permite que administradores criem formulários de avaliação que são respondidos por alunos e professores, gerando relatórios sobre o desempenho das disciplinas e infraestrutura.

### Objetivos Principais

- Automatizar o processo de coleta de feedback sobre disciplinas
- Integrar dados do SIGAA para alimentar a plataforma
- Permitir análise de dados através de exportação em CSV
- Facilitar a gestão de templates reutilizáveis de formulários

### Stakeholders

- **Coordenadores de Curso** (Administradores): Criam e gerenciam formulários
- **Professores**: Respondem questionários sobre infraestrutura e ementa
- **Alunos**: Avaliam disciplinas e professores
- **Sistema SIGAA**: Fornecedor de dados de turmas, disciplinas e participantes

---

## Funcionalidades e Regras de Negócio

### 1. Autenticação de Usuários (2 pontos)

**Funcionalidades:**
- Login com email ou matrícula + senha
- Definir senha após convite de cadastro

**Regras de Negócio:**
- Senhas devem ter no mínimo 4 caracteres
- Senhas devem conter pelo menos: 1 letra maiúscula, 1 letra minúscula, 1 número e 1 caractere especial
- Usuário deve alterar senha temporária no primeiro acesso

**Responsável:** [Nome do desenvolvedor]

---

### 2. Importação de Dados do SIGAA (8 pontos)

**Funcionalidades:**
- Importar turmas, disciplinas e participantes do SIGAA
- Atualizar dados existentes com informações atualizadas
- Marcar turmas como inativas quando descontinuadas

**Regras de Negócio:**
- Importação deve ser realizada apenas por administradores
- Registros duplicados são ignorados (validação por ID único do SIGAA)
- Ao importar novos usuários, criar contas com senha temporária
- Dados importados não devem sobrescrever informações customizadas no sistema
- Participantes removidos do SIGAA devem ter acesso desativado
- Atualização de mudanças de turmas de alunos/professores

**Responsável:** [Nome do desenvolvedor]

---

### 3. Gerenciamento de Templates de Formulários (5 pontos)

**Funcionalidades:**
- Criar templates com múltiplos tipos de questões
- Visualizar templates criados
- Editar templates
- Deletar templates

**Regras de Negócio:**
- Template deve ter no mínimo 1 questão
- Nome do template deve ser único
- Apenas o criador do template pode editá-lo
- Tipos de questões suportados: Múltipla escolha, Texto aberto, Verdadeiro/Falso
- Edições em template afetam apenas novos formulários criados, não retroativamente

**Responsável:** [Nome do desenvolvedor]

---

### 4. Criação de Formulários (8 pontos)

**Funcionalidades:**
- Criar formulário baseado em template
- Selecionar turmas para aplicar o formulário
- Escolher tipo de avaliador (docentes ou discentes)
- Visualizar formulários criados

**Regras de Negócio:**
- Formulário herda todas as questões do template no momento da criação
- Deve selecionar no mínimo 1 turma
- Deve escolher tipo de avaliador (obrigatório)
- Mesmo formulário não pode ser respondido 2 vezes pelo mesmo participante

**Responsável:** [Nome do desenvolvedor]

---

### 5. Resposta de Questionários (5 pontos)

**Funcionalidades:**
- Visualizar formulários não respondidos
- Responder questionário
- Submeter respostas
- Filtrar respostas de turmas

**Regras de Negócio:**
- Participante visualiza apenas formulários de turmas onde está matriculado
- Todos os campos obrigatórios devem ser preenchidos antes de enviar
- Participante pode editar respostas enquanto formulário não foi enviado
- Uma vez enviado, não pode ser alterado
- Resposta não pode ser submetida duas vezes pelo mesmo participante
- Sistema valida tipo de resposta conforme tipo de questão

**Responsável:** [Nome do desenvolvedor]

---

### 6. Exportação de Resultados (5 pontos)

**Funcionalidades:**
- Exportar respostas em formato CSV
- Filtrar por formulário
- Download do arquivo

**Regras de Negócio:**
- Apenas administrador pode exportar resultados
- Arquivo CSV deve conter: ID da resposta, Participante, Data de resposta, Respostas individuais
- Formato CSV deve ser compatível com planilhas
- Caracteres especiais devem estar codificados corretamente (UTF-8)
- Arquivo só pode ser gerado se houver respostas
- Nomes de participantes anonimizados por padrão (apenas matrícula mostrada)
- Arquivo gerado com timestamp: `formulario_[id]_[data_hora].csv`

**Responsável:** [Nome do desenvolvedor]

---

### 7. Diferenciação de Avaliadores (3 pontos)

**Funcionalidades:**
- Escolher tipo de avaliador (docentes ou discentes)
- Exibir formulário apenas para o tipo correto

**Regras de Negócio:**
- Ao criar formulário, obrigatório selecionar tipo: "Docentes" ou "Discentes"
- Aluno só vê formulários criados para "Discentes"
- Professor só vê formulários criados para "Docentes"
- Sistema valida tipo de usuário ao tentar acessar formulário
- Formulário para docente é enviado apenas para professores das turmas
- Formulário para discente é enviado apenas para alunos das turmas
- Mesmo formulário com dois tipos diferentes pode coexistir para mesma turma

**Responsável:** [Nome do desenvolvedor]

---

### 8. Gestão de Usuários e Participantes (3 pontos)

**Funcionalidades:**
- Cadastro automático de participantes na importação
- Desativação de participantes inativos

**Regras de Negócio:**
- Usuários são criados automaticamente durante importação do SIGAA
- Usuário inativo não pode fazer login
- Quando participante é removido do SIGAA, status muda para inativo
- Email de boas-vindas é enviado automaticamente
- Senha temporária é gerada e enviada no email de boas vindas

**Responsável:** [Nome do desenvolvedor]

---

## Atribuição de Histórias de Usuário

| # | História de Usuário | Funcionalidade | Pontos | Responsável |
|---|---------------------|-----------------|--------|-------------|
| 1 | Importar dados do SIGAA | Importação de Dados | 8 | [Nome] |
| 2 | Responder questionário sobre turma | Resposta de Questionários | 5 | [Nome] |
| 3 | Cadastrar participantes ao importar | Gestão de Usuários | 3 | [Nome] |
| 4 | Baixar resultados em CSV | Exportação de Resultados | 5 | [Nome] |
| 5 | Criar template de formulário | Gerenciamento de Templates | 5 | [Nome] |
| 6 | Criar formulário baseado em template | Criação de Formulários | 8 | [Nome] |
| 7 | Acessar sistema com credenciais | Autenticação | 3 | [Nome] |
| 8 | Definir senha após cadastro | Autenticação | 2 | [Nome] |
| 9 | Atualizar base de dados existente | Importação de Dados | 5 | [Nome] |
| 10 | Visualizar formulários não respondidos | Resposta de Questionários | 3 | [Nome] |
| 11 | Visualizar formulários criados | Criação de Formulários | 3 | [Nome] |
| 12 | Visualizar templates criados | Gerenciamento de Templates | 2 | [Nome] |
| 13 | Editar e deletar template | Gerenciamento de Templates | 3 | [Nome] |
| 14 | Escolher tipo de avaliador | Diferenciação de Avaliadores | 3 | [Nome] |

**Total de Pontos: 56 pontos**

---

## Histórias de Usuário Detalhadas com Pontuação

### HU-01: Importar dados do SIGAA (8 pontos)

```
Como Administrador
Quero importar dados de turmas, matérias e participantes do SIGAA
A fim de alimentar a base de dados do sistema

Critérios de Aceitação:
- Sistema importa com sucesso turmas, disciplinas e participantes do SIGAA
- Dados duplicados são ignorados
- Novos usuários recebem email de boas-vindas
- Erro de conexão é tratado graciosamente
- Máximo 1 importação simultânea
```

**Pontos:** 8 | **Responsável:** [Nome]

---

### HU-02: Responder questionário sobre turma (5 pontos)

```
Como Participante de uma turma
Quero responder o questionário sobre a turma em que estou matriculado
A fim de submeter minha avaliação da turma

Critérios de Aceitação:
- Visualiza questionário da turma
- Preenche questões obrigatórias
- Submete respostas finais
- Não pode responder 2 vezes o mesmo formulário
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-03: Cadastrar participantes ao importar (3 pontos)

```
Como Administrador
Quero cadastrar participantes de turmas do SIGAA ao importar dados de usuários novos
A fim de que eles acessem o sistema CAMAAR

Critérios de Aceitação:
- Novos usuários são criados automaticamente
- Senha temporária é gerada
- Usuário deve alterar senha no primeiro acesso
- Usuários já existentes são associados às novas turmas
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-04: Baixar resultados em CSV (5 pontos)

```
Como Administrador
Quero baixar um arquivo CSV contendo os resultados de um formulário
A fim de avaliar o desempenho das turmas

Critérios de Aceitação:
- Arquivo CSV é gerado com estrutura correta
- Colunas: ID, Participante, Data, Respostas
- Caracteres especiais codificados (UTF-8)
- Anonimização de nomes (apenas matrícula)
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-05: Criar template de formulário (5 pontos)

```
Como Administrador
Quero criar um template de formulário contendo as questões
A fim de gerar formulários de avaliações reutilizáveis

Critérios de Aceitação:
- Template com nome único
- Mínimo 1 questão obrigatória
- Suporta múltiplos tipos: múltipla escolha, texto, V/F
- Apenas criador pode editar
- Edições não afetam formulários já criados
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-06: Criar formulário baseado em template (8 pontos)

```
Como Administrador
Quero criar um formulário baseado em um template para turmas escolhidas
A fim de avaliar o desempenho das turmas no semestre atual

Critérios de Aceitação:
- Seleciona template
- Escolhe múltiplas turmas (mínimo 1)
- Escolhe tipo de avaliador (docentes/discentes)
- Formulário herda questões do template
- Notificação enviada aos participantes
```

**Pontos:** 8 | **Responsável:** [Nome]

---

### HU-07: Acessar sistema com credenciais (3 pontos)

```
Como Usuário do sistema
Quero acessar o sistema utilizando email e senha
A fim de responder formulários ou gerenciar o sistema

Critérios de Aceitação:
- Login com email funciona
- Validação de credenciais
- Redirecionamento para painel
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-08: Definir senha após cadastro (2 pontos)

```
Como Usuário
Quero definir uma senha para o meu usuário a partir do email de cadastro
A fim de acessar o sistema

Critérios de Aceitação:
- Senha deve cumprir critérios de segurança
- Senhas devem conferir
- Redirecionamento para login após sucesso
```

**Pontos:** 2 | **Responsável:** [Nome]

---

### HU-09: Atualizar base de dados existente (5 pontos)

```
Como Administrador
Quero atualizar a base de dados com dados atuais do SIGAA
A fim de corrigir a base de dados do sistema

Critérios de Aceitação:
- Sincroniza dados existentes
- Adiciona novos dados
- Atualiza mudanças de turmas
```

**Pontos:** 5 | **Responsável:** [Nome]

---

### HU-10: Visualizar formulários não respondidos (3 pontos)

```
Como Participante de uma turma
Quero visualizar os formulários não respondidos das turmas em que estou matriculado
A fim de poder escolher qual irei responder

Critérios de Aceitação:
- Lista apenas formulários não respondidos
- Mostra turma, disciplina, datas
- Formulários respondidos não aparecem
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-11: Visualizar formulários criados (3 pontos)

```
Como Administrador
Quero visualizar os formulários criados
A fim de poder gerar um relatório a partir das respostas

Critérios de Aceitação:
- Lista todos os formulários
- Mostra nome, template, turmas, status, data
- Quantidade de respostas exibida
- Opção de visualizar detalhes
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-12: Visualizar templates criados (2 pontos)

```
Como Administrador
Quero visualizar os templates criados
A fim de poder editar e/ou deletar um template que eu criei

Critérios de Aceitação:
- Lista todos os templates
- Mostra nome, quantidade de questões, data
- Acesso aos detalhes
- Opções de editar/deletar
```

**Pontos:** 2 | **Responsável:** [Nome]

---

### HU-13: Editar e deletar template (3 pontos)

```
Como Administrador
Quero editar e/ou deletar um template que eu criei sem afetar formulários já criados
A fim de organizar os templates existentes

Critérios de Aceitação:
- Confirmação de exclusão
- Apenas criador pode editar e excluir
```

**Pontos:** 3 | **Responsável:** [Nome]

---

### HU-14: Escolher tipo de avaliador (3 pontos)

```
Como Administrador
Quero escolher criar um formulário para os docentes ou os discentes de uma turma
A fim de avaliar o desempenho de uma matéria

Critérios de Aceitação:
- Opção obrigatória: Docentes ou Discentes
- Professores veem apenas formulários para Docentes
- Alunos veem apenas formulários para Discentes
- Múltiplos formulários podem coexistir para mesma turma
```

**Pontos:** 3 | **Responsável:** [Nome]

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

## Métricas e Velocidade

### Cálculo de Velocity

**Sprint Atual:**
- Total de Pontos: **56 pontos**
- Histórias por Sprint: [A definir conforme organização]

**Fórmula:**
```
Velocity = Pontos Concluídos / Número de Sprints

Exemplo (após 3 sprints):
Sprint 1: 21 pontos
Sprint 2: 18 pontos
Sprint 3: 20 pontos
Velocity Média = (21+18+20)/3 = 19.67 pontos/sprint
```

### Capacidade de Planning

```
Baseado na velocity média, para próxima sprint:
- Pontos a planejar ≈ Velocity média
- Buffer (20% do total) para imprevistos
- Ajustar conforme necessário
```

---

### Estrutura do Banco de Dados:

```

// CAMAAR - Database Schema (DbDiagram.io format)
// Plataforma de Avaliação de Cursos
// Versão: 1.0 (Pós-Remoções)
// Data: 07/12/2025

// ============================================
// ENUMS
// ============================================

Enum user_role {
  aluno
  professor
  admin
}

Enum form_evaluator_type {
  aluno
  professor
}

Enum form_status {
  rascunho
  ativo
  finalizado
}

Enum response_status {
  rascunho
  submetido
}

// ============================================
// TABELAS PRINCIPAIS
// ============================================

Table users {
  id integer [pk, increment]
  name varchar(255) [not null, note: 'Nome completo do usuário']
  email varchar(255) [not null, unique, note: 'Email único do usuário']
  matricula varchar(50) [not null, unique, note: 'Matrícula do SIGAA']
  password_digest varchar [not null, note: 'Senha criptografada (bcrypt)']
  role user_role [not null, note: 'Tipo de usuário: aluno, professor ou admin']
  department_id integer [not null, ref: > departments.id, note: 'Departamento do usuário']
  active boolean [not null, default: true, note: 'Usuário ativo no sistema']
  created_at timestamp [not null, default: 'now()']
  updated_at timestamp [not null, default: 'now()']
  
  indexes {
    (email) [unique, name: 'idx_users_email']
    (matricula) [unique, name: 'idx_users_matricula']
    (department_id) [name: 'idx_users_department_id']
    (role) [name: 'idx_users_role']
  }
  
  Note: 'Usuários do sistema (alunos, professores, administradores)'
}


Table departments {
  id integer [pk, increment]
  name varchar(255) [not null, note: 'Nome do departamento']
  code varchar(20) [not null, unique, note: 'Sigla/código do departamento (ex: CIC, ENE)']
  sigaa_id varchar(50) [note: 'ID do departamento no SIGAA (opcional)']
  created_at timestamp [not null, default: 'now()']
  updated_at timestamp [not null, default: 'now()']
  
  indexes {
    (code) [unique, name: 'idx_departments_code']
    (sigaa_id) [name: 'idx_departments_sigaa_id']
  }
  
  Note: 'Departamentos acadêmicos'
}


Table courses {
  id integer [pk, increment]
  name varchar(255) [not null, note: 'Nome da disciplina']
  code varchar(20) [not null, note: 'Código da disciplina (ex: FGA0208)']
  department_id integer [not null, ref: > departments.id, note: 'Departamento responsável']
  sigaa_id varchar(50) [note: 'ID da disciplina no SIGAA (opcional)']
  created_at timestamp [not null, default: 'now()']
  updated_at timestamp [not null, default: 'now()']
  
  indexes {
    (code, department_id) [unique, name: 'idx_courses_code_dept']
    (department_id) [name: 'idx_courses_department_id']
    (sigaa_id) [name: 'idx_courses_sigaa_id']
  }
  
  Note: 'Disciplinas/Cursos oferecidos'
}


Table classes {
  id integer [pk, increment]
  course_id integer [not null, ref: > courses.id, note: 'Disciplina da turma']
  professor_id integer [not null, ref: > users.id, note: 'Professor responsável (role=professor)']
  semester varchar(10) [not null, note: 'Semestre/período (ex: 2025.2)']
  turma_code varchar(10) [not null, note: 'Código da turma (ex: A, B, 01)']
  sigaa_id varchar(50) [note: 'ID da turma no SIGAA (opcional)']
  active boolean [not null, default: true, note: 'Turma ativa']
  created_at timestamp [not null, default: 'now()']
  updated_at timestamp [not null, default: 'now()']
  
  indexes {
    (course_id, semester, turma_code) [unique, name: 'idx_classes_unique']
    (course_id) [name: 'idx_classes_course_id']
    (professor_id) [name: 'idx_classes_professor_id']
    (semester) [name: 'idx_classes_semester']
    (sigaa_id) [name: 'idx_classes_sigaa_id']
    (active) [name: 'idx_classes_active']
  }
  
  Note: 'Turmas específicas de um curso em um semestre'
}


Table templates {
  id integer [pk, increment]
  title varchar(255) [not null, note: 'Título do template']
  description text [note: 'Descrição/instruções do template']
  questions jsonb [not null, note: 'Array JSON com questões estruturadas']
  creator_id integer [not null, ref: > users.id, note: 'Admin que criou o template (role=admin)']
  department_id integer [not null, ref: > departments.id, note: 'Departamento proprietário']
  created_at timestamp [not null, default: 'now()']
  updated_at timestamp [not null, default: 'now()']
  
  indexes {
    (creator_id) [name: 'idx_templates_creator_id']
    (department_id) [name: 'idx_templates_department_id']
    (title, department_id) [unique, name: 'idx_templates_title_dept']
  }
  
  Note: '''Template reutilizável de formulário de avaliação
  
  Estrutura esperada do campo questions:
  [
    {
      "id": "q1",
      "text": "Pergunta?",
      "type": "multiple_choice | text | boolean",
      "required": true,
      "options": ["Op1", "Op2"] // se multiple_choice
    }
  ]'''
}


Table forms {
  id integer [pk, increment]
  title varchar(255) [not null, note: 'Título do formulário']
  description text [note: 'Descrição/instruções do formulário']
  questions jsonb [not null, note: 'Array JSON com questões estruturadas (cópia do template)']
  evaluator_type form_evaluator_type [not null, note: 'Quem deve responder: aluno ou professor']
  creator_id integer [not null, ref: > users.id, note: 'Admin que criou o formulário (role=admin)']
  template_id integer [ref: > templates.id, note: 'Template usado como base (rastreamento)']
  status form_status [not null, default: 'rascunho', note: 'Estado do formulário']
  start_date date [note: 'Data de início da avaliação']
  end_date date [note: 'Data limite da avaliação']
  created_at timestamp [not null, default: 'now()']
  updated_at timestamp [not null, default: 'now()']
  
  indexes {
    (status) [name: 'idx_forms_status']
    (start_date, end_date) [name: 'idx_forms_date_range']
    (creator_id) [name: 'idx_forms_creator_id']
    (template_id) [name: 'idx_forms_template_id']
  }
  
  Note: '''Formulários de avaliação
  
  Estrutura esperada do campo questions:
  [
    {
      "id": "q1",
      "text": "Pergunta?",
      "type": "multiple_choice | text | boolean",
      "required": true,
      "options": ["Op1", "Op2"] // se multiple_choice
    }
  ]'''
}


Table responses {
  id integer [pk, increment]
  form_id integer [not null, ref: > forms.id, note: 'Formulário respondido']
  user_id integer [not null, ref: > users.id, note: 'Usuário que respondeu']
  class_id integer [ref: > classes.id, note: 'Turma avaliada (opcional)']
  answers jsonb [not null, note: 'Array JSON com respostas']
  status response_status [not null, default: 'rascunho', note: 'Estado da resposta']
  submitted_at timestamp [note: 'Data/hora de submissão']
  created_at timestamp [not null, default: 'now()']
  updated_at timestamp [not null, default: 'now()']
  
  indexes {
    (form_id, user_id) [unique, name: 'idx_responses_unique']
    (user_id) [name: 'idx_responses_user_id']
    (status) [name: 'idx_responses_status']
    (submitted_at) [name: 'idx_responses_submitted_at']
  }
  
  Note: '''Respostas dos participantes a formulários
  
  Estrutura esperada do campo answers:
  [
    {
      "question_id": "q1",
      "value": "Resposta"
    }
  ]
  
  Constraint: um usuário responde apenas uma vez por formulário (unique em form_id, user_id)'''
}


// ============================================
// TABELAS DE JUNÇÃO (Many-to-Many)
// ============================================


Table classes_users {
  class_id integer [not null, ref: > classes.id, note: 'Turma']
  user_id integer [not null, ref: > users.id, note: 'Aluno (role=aluno) matriculado']
  created_at timestamp [not null, default: 'now()']
  
  indexes {
    (class_id, user_id) [pk, unique, name: 'idx_classes_users_pk']
    (user_id) [name: 'idx_classes_users_user_id']
  }
  
  Note: 'Relacionamento muitos-para-muitos: alunos matriculados em turmas'
}


Table forms_classes {
  form_id integer [not null, ref: > forms.id, note: 'Formulário de avaliação']
  class_id integer [not null, ref: > classes.id, note: 'Turma que deve responder']
  created_at timestamp [not null, default: 'now()']
  
  indexes {
    (form_id, class_id) [pk, unique, name: 'idx_forms_classes_pk']
    (class_id) [name: 'idx_forms_classes_class_id']
  }
  
  Note: 'Relacionamento muitos-para-muitos: turmas associadas a formulários'
}

```
---

### Arquivo classes.json (exemplo)

```

[
    {
        "code": "CIC0097",
        "name": "BANCOS DE DADOS",
        "class": {
            "classCode": "TA",
            "semester": "2021.2",
            "time": "35T45"
        }
    },
    {
        "code": "CIC0105",
        "name": "ENGENHARIA DE SOFTWARE",
        "class": {
            "classCode": "TA",
            "semester": "2021.2",
            "time": "35M12"
        }
    },
    {
        "code": "CIC0202",
        "name": "PROGRAMAÇÃO CONCORRENTE",
        "class": {
            "classCode": "TA",
            "semester": "2021.2",
            "time": "35M34"
        }
    }
]

```

### Arquivo class_members.json (exemplo):

```

[
    {
        "code": "CIC0097",
        "classCode": "TA",
        "semester": "2021.2",
        "dicente": [
            {
                "nome": "Ana Clara Jordao Perna",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190084006",
                "usuario": "190084006",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "acjpjvjp@gmail.com"
            },
            {
                "nome": "Andre Carvalho de Roure",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "200033522",
                "usuario": "200033522",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "andreCarvalhoroure@gmail.com"
            },
            {
                "nome": "André Carvalho Marques",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "150005491",
                "usuario": "150005491",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "andre.acm97@outlook.com"
            },
            {
                "nome": "Antonio Vinicius de Moura Rodrigues",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190084502",
                "usuario": "190084502",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "antoniovmoura.r@gmail.com"
            },
            {
                "nome": "Arthur Barreiros de Oliveira Mota",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190102829",
                "usuario": "190102829",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "arthurbarreirosmota@gmail.com"
            },
            {
                "nome": "ARTHUR RODRIGUES NEVES",
                "curso": "ENGENHARIA DE COMPUTAÇÃO/CIC",
                "matricula": "202014403",
                "usuario": "202014403",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "arthurcontroleambiental@gmail.com"
            },
            {
                "nome": "Bianca Glycia Boueri",
                "curso": "ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD",
                "matricula": "170161561",
                "usuario": "170161561",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "biancaglyciaboueri@gmail.com"
            },
            {
                "nome": "Caio Otávio Peluti Alencar",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190085312",
                "usuario": "190085312",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "peluticaio@gmail.com"
            },
            {
                "nome": "Camila Frealdo Fraga",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "170007561",
                "usuario": "170007561",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "camilizx2021@gmail.com"
            },
            {
                "nome": "Claudio Roberto Oliveira Peres de Barros",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190097591",
                "usuario": "190097591",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "dinhobarros15@gmail.com"
            },
            {
                "nome": "Daltro Oliveira Vinuto",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "160025966",
                "usuario": "160025966",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "daltroov777@gmail.com"
            },
            {
                "nome": "Davi de Moura Amaral",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "200016750",
                "usuario": "200016750",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "davimouraamaral@gmail.com"
            },
            {
                "nome": "Eduardo Xavier Dantas",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190086530",
                "usuario": "190086530",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "eduardoxdantas@gmail.com"
            },
            {
                "nome": "Enzo Nunes Leal Sampaio",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190062789",
                "usuario": "190062789",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "enzonleal2016@hotmail.com"
            },
            {
                "nome": "Enzo Yoshio Niho",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190027304",
                "usuario": "190027304",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "enzoyn@hotmail.com"
            },
            {
                "nome": "Gabriel Faustino Lima da Rocha",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190013249",
                "usuario": "190013249",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "gabrielfaustino99@gmail.com"
            },
            {
                "nome": "Gabriel Ligoski",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190087498",
                "usuario": "190087498",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "gabriel.ligoski@gmail.com"
            },
            {
                "nome": "GABRIEL MENDES CIRIATICO GUIMARÃES",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "202033202",
                "usuario": "202033202",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "gabrielciriatico@gmail.com"
            },
            {
                "nome": "Gustavo Rodrigues dos Santos",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190014121",
                "usuario": "190014121",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "190014121@aluno.unb.br"
            },
            {
                "nome": "Gustavo Rodrigues Gualberto",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190108266",
                "usuario": "190108266",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "gustavorgualberto@gmail.com"
            },
            {
                "nome": "Igor David Morais",
                "curso": "ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD",
                "matricula": "180102141",
                "usuario": "180102141",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "igordavid13@gmail.com"
            },
            {
                "nome": "Jefte Augusto Gomes Batista",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "180057570",
                "usuario": "180057570",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "ndaffte@gmail.com"
            },
            {
                "nome": "Karolina de Souza Silva",
                "curso": "ENGENHARIA DE COMPUTAÇÃO/CIC",
                "matricula": "190046791",
                "usuario": "190046791",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "karolinasouza@outlook.com"
            },
            {
                "nome": "Kléber Rodrigues da Costa Júnior",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "200053680",
                "usuario": "200053680",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "kleberrjr7@gmail.com"
            },
            {
                "nome": "Luca Delpino Barbabella",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "180125559",
                "usuario": "180125559",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "barbadluca@gmail.com"
            },
            {
                "nome": "Lucas de Almeida Abreu Faria",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "170016668",
                "usuario": "170016668",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "lucasaafaria@gmail.com"
            },
            {
                "nome": "Lucas Gonçalves Ramalho",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190098091",
                "usuario": "190098091",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "lucasramalho29@gmail.com"
            },
            {
                "nome": "Lucas Monteiro Miranda",
                "curso": "ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD",
                "matricula": "170149684",
                "usuario": "170149684",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "luquinha_miranda@hotmail.com"
            },
            {
                "nome": "Lucas Resende Silveira Reis",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "180144421",
                "usuario": "180144421",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "180144421@aluno.unb.br"
            },
            {
                "nome": "Luis Fernando Freitas Lamellas",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190016841",
                "usuario": "190016841",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "lflamellas@icloud.com"
            },
            {
                "nome": "Luiza de Araujo Nunes Gomes",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190112794",
                "usuario": "190112794",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "luizangomes@outlook.com"
            },
            {
                "nome": "Marcelo Aiache Postiglione",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "180126652",
                "usuario": "180126652",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "180126652@aluno.unb.br"
            },
            {
                "nome": "Marcelo Junqueira Ferreira",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "200023624",
                "usuario": "200023624",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "marcelojunqueiraf@gmail.com"
            },
            {
                "nome": "MARIA EDUARDA CARVALHO SANTOS",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190092556",
                "usuario": "190092556",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "auntduda@gmail.com"
            },
            {
                "nome": "Maria Eduarda Lacerda Dantas",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "200067184",
                "usuario": "200067184",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "lacwerda@gmail.com"
            },
            {
                "nome": "Maylla Krislainy de Sousa Silva",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190043873",
                "usuario": "190043873",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "mayllak@hotmail.com"
            },
            {
                "nome": "Pedro Cesar Ribeiro Passos",
                "curso": "ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD",
                "matricula": "180139312",
                "usuario": "180139312",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "pedrocesarribeiro2013@gmail.com"
            },
            {
                "nome": "Rafael Mascarenhas Dal Moro",
                "curso": "ENGENHARIA DE COMPUTAÇÃO/CIC",
                "matricula": "170021041",
                "usuario": "170021041",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "170021041@aluno.unb.br"
            },
            {
                "nome": "Rodrigo Mamedio Arrelaro",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190095164",
                "usuario": "190095164",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "arrelaro1@hotmail.com"
            },
            {
                "nome": "Thiago de Oliveira Albuquerque",
                "curso": "ENGENHARIA DE COMPUTAÇÃO/CIC",
                "matricula": "140177442",
                "usuario": "140177442",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "thiago.work.ti@outlook.com"
            },
            {
                "nome": "Thiago Elias dos Reis",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190126892",
                "usuario": "190126892",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "thiagoeliasdosreis01@gmail.com"
            },
            {
                "nome": "Victor Hugo Rodrigues Fernandes",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "180132041",
                "usuario": "180132041",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "aluno0sem.luz@gmail.com"
            },
            {
                "nome": "Vinicius Lima Passos",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "200028545",
                "usuario": "200028545",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "viniciuslimapassos@gmail.com"
            },
            {
                "nome": "William Xavier dos Santos",
                "curso": "CIÊNCIA DA COMPUTAÇÃO/CIC",
                "matricula": "190075384",
                "usuario": "190075384",
                "formacao": "graduando",
                "ocupacao": "dicente",
                "email": "wilxavier@me.com"
            }
        ],
        "docente": {
            "nome": "MARISTELA TERTO DE HOLANDA",
            "departamento": "DEPTO CIÊNCIAS DA COMPUTAÇÃO",
            "formacao": "DOUTORADO",
            "usuario": "83807519491",
            "email": "mholanda@unb.br",
            "ocupacao": "docente"
        }
    }
]

```
