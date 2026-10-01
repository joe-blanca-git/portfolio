-- =====================================================================
-- Portfólio Joeder Blanca - criação do banco (MySQL 8+)
--
-- Cria o banco, as tabelas e popula com o conteúdo atual do site.
-- Pode ser executado de novo: as tabelas são recriadas do zero.
-- ATENÇÃO: rodar novamente APAGA os dados existentes.
--
-- Depois de rodar:
--   1. (opcional) dados_migracao.sql -> posts e projetos vindos do Supabase
--   2. python manage.py criar-admin  -> cria o usuário do painel
-- =====================================================================

CREATE DATABASE IF NOT EXISTS portfolio
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE portfolio;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS skill_categories;
DROP TABLE IF EXISTS profile;
DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS about_highlights;
DROP TABLE IF EXISTS timeline;
DROP TABLE IF EXISTS awards;
DROP TABLE IF EXISTS certificates;
DROP TABLE IF EXISTS experiences;
DROP TABLE IF EXISTS education;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS admin_users;

SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- Perfil: textos fixos do site (hero, sobre mim, citações, contato).
-- Registro único com id = 1.
-- ---------------------------------------------------------------------
CREATE TABLE profile (
  id                      TINYINT UNSIGNED NOT NULL DEFAULT 1,
  full_name               VARCHAR(120) NOT NULL,
  role_title              VARCHAR(160) NULL,
  hero_greeting           VARCHAR(160) NULL,
  hero_title              VARCHAR(80)  NULL,
  hero_typed_items        VARCHAR(255) NULL COMMENT 'Palavras do efeito de digitação, separadas por vírgula',
  hero_lead               TEXT NULL,
  hero_image              VARCHAR(1000) NULL,
  hero_badges             VARCHAR(255) NULL COMMENT 'Cards flutuantes da foto, separados por vírgula',
  years_experience        TINYINT UNSIGNED NULL,
  about_subtitle          VARCHAR(255) NULL,
  about_title             VARCHAR(255) NULL,
  about_text              TEXT NULL,
  about_image             VARCHAR(1000) NULL,
  signature_image         VARCHAR(1000) NULL,
  about_quote             VARCHAR(255) NULL,
  skills_summary_title    VARCHAR(120) NULL,
  skills_summary_text     TEXT NULL,
  experience_quote        VARCHAR(255) NULL,
  experience_quote_author VARCHAR(120) NULL,
  education_quote         VARCHAR(255) NULL,
  education_quote_author  VARCHAR(120) NULL,
  contact_title           VARCHAR(160) NULL,
  contact_text            TEXT NULL,
  contact_image           VARCHAR(1000) NULL,
  location                VARCHAR(160) NULL,
  footer_tagline          VARCHAR(255) NULL,
  updated_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT chk_profile_single CHECK (id = 1)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Contatos e redes sociais
--   show_in_contact -> aparece no card da seção Contato (agrupado por label)
--   show_in_social  -> aparece nos ícones do hero, rodapé e botões do contato
-- ---------------------------------------------------------------------
CREATE TABLE contacts (
  id              INT UNSIGNED NOT NULL AUTO_INCREMENT,
  type            VARCHAR(30)  NOT NULL,
  label           VARCHAR(80)  NOT NULL,
  value           VARCHAR(255) NOT NULL,
  url             VARCHAR(500) NULL,
  icon            VARCHAR(60)  NULL,
  show_in_contact TINYINT(1)   NOT NULL DEFAULT 1,
  show_in_social  TINYINT(1)   NOT NULL DEFAULT 0,
  sort_order      INT UNSIGNED NOT NULL DEFAULT 0,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Cards de destaque da seção Sobre mim
CREATE TABLE about_highlights (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  title       VARCHAR(80)  NOT NULL,
  description VARCHAR(255) NULL,
  icon        VARCHAR(60)  NULL,
  color       VARCHAR(9)   NULL,
  sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Linha do tempo da seção Sobre mim
CREATE TABLE timeline (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  year        VARCHAR(20)  NOT NULL,
  description VARCHAR(255) NOT NULL,
  sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Habilidades agrupadas por categoria
CREATE TABLE skill_categories (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  title      VARCHAR(80) NOT NULL,
  icon       VARCHAR(60) NULL,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE skills (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_id INT UNSIGNED NOT NULL,
  name        VARCHAR(120) NOT NULL,
  level       TINYINT UNSIGNED NOT NULL DEFAULT 0,
  sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  KEY idx_skills_category (category_id),
  CONSTRAINT fk_skills_category FOREIGN KEY (category_id)
    REFERENCES skill_categories (id) ON DELETE CASCADE,
  CONSTRAINT chk_skills_level CHECK (level <= 100)
) ENGINE=InnoDB;

-- Conquistas (bloco "Destaques" ao lado das habilidades)
CREATE TABLE awards (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  value      VARCHAR(20)  NULL,
  title      VARCHAR(120) NOT NULL,
  subtitle   VARCHAR(160) NULL,
  icon       VARCHAR(60)  NULL,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE certificates (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name       VARCHAR(200) NOT NULL,
  sort_order INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Carreira: experiência profissional (achievements = um item por linha)
CREATE TABLE experiences (
  id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  role         VARCHAR(160) NOT NULL,
  company      VARCHAR(160) NOT NULL,
  period       VARCHAR(60)  NOT NULL,
  description  TEXT NULL,
  achievements TEXT NULL,
  sort_order   INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Carreira: formação acadêmica
CREATE TABLE education (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  degree      VARCHAR(200) NOT NULL,
  institution VARCHAR(160) NOT NULL,
  period      VARCHAR(60)  NOT NULL,
  description TEXT NULL,
  sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE courses (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  title       VARCHAR(160) NOT NULL,
  institution VARCHAR(120) NOT NULL,
  year        VARCHAR(40)  NULL,
  icon        VARCHAR(60)  NULL,
  sort_order  INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Blog
CREATE TABLE posts (
  id         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  title      VARCHAR(255)  NOT NULL,
  tag        VARCHAR(255)  NULL,
  img_header VARCHAR(1000) NULL,
  content    MEDIUMTEXT    NULL,
  images     JSON          NULL COMMENT 'Lista de URLs da galeria',
  published  TINYINT(1)    NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_posts_published (published, created_at)
) ENGINE=InnoDB;

-- Portfólio (category: filter-api | filter-plataform | filter-site)
CREATE TABLE projects (
  id           INT UNSIGNED NOT NULL AUTO_INCREMENT,
  title        VARCHAR(160)  NOT NULL,
  category     VARCHAR(40)   NOT NULL,
  image_url    VARCHAR(1000) NULL,
  project_link VARCHAR(1000) NULL,
  description  TEXT NULL,
  sort_order   INT UNSIGNED NOT NULL DEFAULT 0,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Usuários do painel (crie com: python manage.py criar-admin)
CREATE TABLE admin_users (
  id            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  email         VARCHAR(190) NOT NULL,
  name          VARCHAR(120) NULL,
  password_hash VARCHAR(255) NOT NULL,
  last_login_at TIMESTAMP NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_admin_email (email)
) ENGINE=InnoDB;

-- =====================================================================
-- Conteúdo atual do site
-- =====================================================================

INSERT INTO profile (
  id, full_name, role_title, hero_greeting, hero_title, hero_typed_items, hero_lead,
  hero_image, hero_badges, years_experience, about_subtitle, about_title, about_text,
  about_image, signature_image, about_quote, skills_summary_title, skills_summary_text,
  experience_quote, experience_quote_author, education_quote, education_quote_author,
  contact_title, contact_text, contact_image, location, footer_tagline
) VALUES (
  1,
  'Joeder Blanca',
  'Desenvolvedor de Sistemas',
  'Olá, eu sou Joeder Blanca',
  'Dev',
  'Web, API''s, Frontend, Backend',
  'Crio experiências digitais que inspiram, engajam e trazem resultados. Apaixonado por desenvolvimento de integrações e soluções inovadoras, transformando ideias em realidades funcionais.',
  'assets/img/profile/profile-square-2.png',
  'Web, Desenvolvimento, Soluções Inovadoras',
  4,
  'Grandes coisas nunca vêm da zona de conforto',
  'Olá, Eu sou Joeder Blanca, Desenvolvedor de Sistemas',
  'Profissional com experiência no desenvolvimento de sistemas voltados para o setor sucroalcooleiro, com ênfase em integrações entre plataformas, APIs e soluções de agricultura de precisão. Atuação destacada em projetos que envolvem conectividade com ferramentas como o Operations Center da John Deere, promovendo automação, eficiência operacional e inteligência na gestão agrícola.',
  'assets/img/profile/profile-square-3.png',
  'assets/img/misc/signature-2.png',
  'Soluções digitais que unem inovação, estratégia e excelência.',
  'Destaques',
  'A cada novo dia, temos a chance de fazer melhor. Crescer é uma escolha diária.',
  'Você não se afoga por cair na água, mas por ficar lá.',
  'Ed Cole',
  'O caminho mais certo para o sucesso é sempre tentar apenas uma vez mais.',
  'Thomas A. Edison',
  'Vamos conversar',
  'Disponível para novos projetos, integrações e parcerias. Escolha o canal que preferir.',
  'assets/img/profile/joe.png',
  'Ituverava - São Paulo',
  'Desenvolvedor de Sistemas · Integrações, APIs e Agricultura de Precisão'
);

INSERT INTO contacts (type, label, value, url, icon, show_in_contact, show_in_social, sort_order) VALUES
  ('phone',     'Fone',            '(16) 9 8876-6522',                 'tel:+5516988766522',                                  'bi-telephone',       1, 0, 1),
  ('email',     'E-mail',          'joeblanca@hotmail.com',            'mailto:joeblanca@hotmail.com',                        'bi-envelope',        1, 0, 2),
  ('email',     'E-mail',          'joeder-blanca@altamogiana.com.br', 'mailto:joeder-blanca@altamogiana.com.br',             'bi-envelope',        1, 0, 3),
  ('linkedin',  'LinkedIn',        'joeder-blanca',                    'https://www.linkedin.com/in/joeder-blanca-032577201/', 'bi-linkedin',        0, 1, 4),
  ('teams',     'Microsoft Teams', 'Microsoft Teams',                  'https://teams.microsoft.com/v2/',                     'bi-microsoft-teams', 0, 1, 5),
  ('instagram', 'Instagram',       '@joe_blanca',                      'https://www.instagram.com/joe_blanca/',               'bi-instagram',       0, 1, 6);

INSERT INTO about_highlights (title, description, icon, color, sort_order) VALUES
  ('Frontend Dev',      'Plataformas e Sites',                          'bi-at',         '#dc3545', 1),
  ('Api''s',            'API''s Rest e Integrações entre Sistemas',     'bi-code-slash', NULL,      2),
  ('Operations Center', 'Integração com Operations Center John Deere',  'bi-pin-map',    '#198754', 3);

INSERT INTO timeline (year, description, sort_order) VALUES
  ('2026', 'Início da Pós Graduação em Engenharia de Software com IA', 1),
  ('2025', 'Promovido para Programador na Usina Alta Mogiana S/A', 2),
  ('2024', 'Conclusão da Graduação de Tecnólogo em Análise e Desenvolvimento de Sistemas', 3),
  ('2022', 'Contratado pela Usina Alta Mogiana S/A', 4),
  ('2022', 'Conclusão do Ensino Técnico em Análise e Desenvolvimento de Sistemas', 5),
  ('2021', 'Conclusão do Ensino Técnico em Administração', 6);

INSERT INTO skill_categories (id, title, icon, sort_order) VALUES
  (1, 'Desenvolvimento Frontend', 'bi-code-slash',       1),
  (2, 'Desenvolvimento Backend',  'bi-server',           2),
  (3, 'Integrações',              'bi-code-square',      3),
  (4, 'DevOps',                   'bi-arrow-left-right', 4);

INSERT INTO skills (category_id, name, level, sort_order) VALUES
  (1, 'HTML/CSS', 90, 1),
  (1, 'JavaScript', 80, 2),
  (1, 'TypeScript', 90, 3),
  (2, 'C# Web Api', 60, 1),
  (2, 'Oracle', 90, 2),
  (2, 'MySQL', 70, 3),
  (3, 'Operations Center - John Deere', 98, 1),
  (3, 'GEC - Gestão de Contratos', 95, 2),
  (3, 'Bem Agro', 70, 3),
  (4, 'Metodologias Ágeis', 90, 1),
  (4, 'Microsoft Azure', 80, 2),
  (4, 'Git', 70, 3);

INSERT INTO awards (value, title, subtitle, icon, sort_order) VALUES
  ('+1', 'Melhor Aluno', 'Técnico em Análise e Des. de Sistemas', 'bi-award', 1),
  ('+1', 'Melhor Aluno', 'Técnico em Administração',              'bi-award', 2);

INSERT INTO certificates (name, sort_order) VALUES
  ('Engenharia de Software - Alura', 1),
  ('C# e ASP.NET Framework Full-Stack - TreinaWeb', 2),
  ('Metodologia DevOps - Alura', 3);

INSERT INTO experiences (role, company, period, description, achievements, sort_order) VALUES
  ('Programador JR', 'Usina Alta Mogiana', '2022 - Atualmente',
   'Responsável pelo desenvolvimento de sistemas (C#, ASP.NET, Angular, TypeScript, Oracle), com foco em integrações via Web, API e soluções de agricultura de precisão, especialmente com o Operations Center da John Deere. Atuo também na documentação técnica, suporte e treinamento de usuários, além da criação de materiais gráficos como tutoriais e vídeos explicativos. Trabalho com processos ágeis e sou especialista em desenvolvimento de APIs e integrações entre sistemas.',
   'Desenvolvimento de Integrações e API''s\nDesenvolvimento do Projeto Integração com Operations Center e Work Planner\nDesenvolvimento de Materiais de Apoio para Depto. de Treinamento\nTreinamento de Operadores sobre o uso de Work Planner - John Deere',
   1),
  ('Vendedor Externo', 'V.Z Industria de Alimentos', '2021 - 2022',
   'Atuação como Vendedor Externo no setor de bebidas, com foco no atendimento a redes de supermercados nas regiões de Franca. Responsável pelo planejamento de vendas, cumprimento de metas.',
   'Vendas Externas de Alimentos para Atacadistas e Varejistas\nProspecção e Atendimento ao Cliente\nPlanejamento de Vendas',
   2),
  ('Vendedor Externo - Supervisor Auxiliar', 'Ambev - Revenda Rizatti', '2013 - 2019',
   'Atuação como Vendedor Externo no setor de bebidas, com foco no atendimento a redes de supermercados nas regiões de Franca. Responsável pelo planejamento de vendas, cumprimento de metas.',
   'Supervisão de Processos da Equipe de Vendas\nPlanejamento de Vendas\nDistribuição de Metas\nVendas Externas de Bebidas para Atacadistas e Varejistas\nProspecção e Atendimento ao Cliente',
   3),
  ('Instrutor Profissionalizante', 'L.C Rodrigues - Informática LTDA', '2009 - 2013',
   'Atuação como Professor nível médio de Informática Profissionalizante para jovens e adultos. Especializado em Pacotes Office. Atuei com desenvolvimento de cursos e conteúdo. Palestras sobre informatização no mercado de trabalho.',
   'Desenvolvimento de Apostilas e Material de Aula para Cursos Profissionalizantes\nDesenvolvimento de Curso Profissionalizante completo sobre Informatização no Mercado de Trabalho\nMinistração de Aulas',
   4);

INSERT INTO education (degree, institution, period, description, sort_order) VALUES
  ('Pós Graduação em Engenharia de Software com Inteligência Artificial', 'Universidade Anhanguera', '2026 - Cursando',
   'Pós-graduação focada na integração entre Engenharia de Software e Inteligência Artificial, abordando desde fundamentos de IA até aplicações avançadas em sistemas modernos. O curso explora Machine Learning, Deep Learning, modelos generativos (GANs, VAEs e Flow-Based Models), além de ferramentas e práticas do ciclo de desenvolvimento de software. Também inclui temas essenciais como Clean Code, Design Patterns, controle de versões, linguagens para ciência de dados e LGPD, formando uma base sólida para criação de sistemas inteligentes, escaláveis e seguros.',
   1),
  ('Tecnólogo em Análise e Desenvolvimento de Sistemas', 'Universidade Paulista - UNIP', '2022 - 2024',
   'Formação superior voltada para o desenvolvimento de soluções tecnológicas, abrangendo programação, bancos de dados, engenharia de software e infraestrutura de sistemas. O curso proporciona conhecimentos em análise de requisitos, modelagem de sistemas, linguagens de programação e gestão de projetos, preparando profissionais para atuar no planejamento, desenvolvimento e manutenção de aplicações voltadas ao mercado corporativo e à transformação digital.',
   2),
  ('Técnico em Análise e Desenvolvimento de Sistemas', 'ETEC - José Ignácio Azevedo Filho', '2021 - 2022',
   'Curso técnico com foco em fundamentos da computação, lógica de programação, banco de dados e desenvolvimento de sistemas. Proporciona habilidades práticas em análise de requisitos, construção de aplicações e suporte a usuários, preparando profissionais para atuar em ambientes corporativos e dar suporte a projetos de tecnologia da informação.',
   3),
  ('Técnico em Administração', 'ETEC - José Ignácio Azevedo Filho', '2020 - 2021',
   'Formação técnica voltada para os principais processos administrativos, incluindo gestão de pessoas, finanças, marketing e operações. O curso desenvolve competências em planejamento estratégico, controle organizacional e apoio à tomada de decisões, capacitando profissionais para atuar em diferentes áreas da administração e contribuir para a eficiência e crescimento das organizações.',
   4);

INSERT INTO courses (title, institution, year, icon, sort_order) VALUES
  ('Desenvolvimento Web - Design e Linguagens', 'TreinaWeb', '2025 - Cursando', 'bi-filetype-html',  1),
  ('C# e ASP.NET Framework Full-Stack',         'TreinaWeb', '2025 - Cursando', 'bi-code-slash',     2),
  ('Eng. de Software - Metodologias Ágeis',     'TreinaWeb', '2025',            'bi-diagram-3',      3),
  ('Angular TS',                                'Udemy',     '2024',            'bi-braces',         4),
  ('Web API .NET Core',                         'Udemy',     '2024',            'bi-hdd-network',    5),
  ('JS - TS - CSS - HTML5',                     'DESEN.IO',  '2024',            'bi-code',           6),
  ('Gestão de Projetos',                        'Alura',     '2023',            'bi-kanban',         7),
  ('Banco de Dados Oracle',                     'Alura',     '2023',            'bi-database',       8),
  ('Engenharia de Software',                    'Alura',     '2022',            'bi-cpu',            9),
  ('API Rest | Web API .NET Core',              'Alura',     '2022',            'bi-hdd-stack',     10),
  ('Modelagem de Dados',                        'Alura',     '2022',            'bi-diagram-2',     11),
  ('Metodologia DevOps',                        'Alura',     '2022',            'bi-cloud-arrow-up', 12);
