-- =====================================================================
-- Migração dos posts e projetos que estavam no Supabase
-- Gerado em 2026-09-30 12:48. Rode depois do script.sql.
-- Os IDs originais são mantidos para os links ?post=ID continuarem válidos.
-- =====================================================================

USE portfolio;
SET NAMES utf8mb4;

DELETE FROM posts;
DELETE FROM projects;

INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (1, 'Vision Tech Summit', 'Evento', 'https://revistarpanews.com.br/wp-content/uploads/2024/08/Vision-Tech-Summit_Industria-do-Amanha_Img.png', 'Tive o prazer de participar do Vision Tech Summit em Ribeirão Preto, na companhia do meu amigo Hernani Mazier. Foi uma excelente experiência nesta conferência de inovação, tecnologia e transformação digital para o agronegócio.', '["https://visaoagro.com.br/wp-content/uploads/2024/09/andre-lins-1-1024x683.jpg"]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (2, 'Usina Alta Mogiana celebra 42 anos.', 'Celebração', 'assets/img/events/evento4.jpeg', 'Neste mês de outubro celebramos com gratidão e orgulho os 42 anos da nossa história. Uma trajetória construída com muito trabalho, superação e, acima de tudo, pelo compromisso de pessoas que acreditam em fazer a diferença todos os dias. Ao longo desse caminho, não acumulamos apenas números, mas histórias de crescimento, inovação e contribuição para o desenvolvimento da nossa região, que se fortalece junto com a nossa evolução.

Essa construção só é possível porque caminhamos lado a lado com colaboradores, parceiros e clientes, que transformam desafios em resultados e metas em grandes conquistas. Vocês são a base que sustenta cada passo dessa jornada.

E é com essa mesma energia, união e determinação que seguimos em frente, prontos para escrever os próximos capítulos e construir juntos um futuro ainda mais promissor.', '["assets/img/events/usina1.jpeg", "assets/img/events/usina2.webp", "assets/img/events/usina3.avif"]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (3, 'Fim das Ilhas Digitais no Campo', 'Publicação', 'https://agriq.com.br/wp-content/uploads/2021/08/Blog-AgriQ-Agricultura-de-precisao_Creditos-Shutterstock.jpg', 'O agronegócio moderno é um oceano de dados. Sensores no solo, drones mapeando o talhão, tratores com GPS e piloto automático, estações meteorológicas, softwares de gestão (ERPs)... a quantidade de tecnologia disponível é impressionante. No entanto, por muito tempo, cada uma dessas tecnologias funcionou como uma <b>ilha digital</b>.<br><br>O trator coletava dados de plantio, o drone gerava mapas de saúde da lavoura, e o ERP controlava o financeiro, mas esses sistemas raramente conversavam entre si. É aqui que a integração de sistemas entra como a verdadeira força motriz da agricultura de precisão.<br><br>A agricultura de precisão não é mais sobre ter o melhor trator ou o melhor drone. É sobre ter o ecossistema mais inteligente e conectado. A fazenda do futuro não é a que tem mais tecnologia, mas aquela onde todas as tecnologias dialogam perfeitamente entre si.', '["https://media-agro.estadao.com.br/uploads/2021/01/665.jpg", "https://www.totvs.com/wp-content/uploads/2024/12/agricultura-de-precisao-capa.jpg"]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (4, 'II Workshop de Tecn. Canavieira Tracbel', 'Evento', 'assets/img/events/evento3.jpeg', 'No dia 02 de outubro de 2025, tive a oportunidade de participar do II Workshop de Tecnologia Canavieira, realizado na unidade de Bebedouro (SP) e promovido pela John Deere e pela Tracbel Agro. O evento reuniu cerca de 200 participantes, entre especialistas, parceiros, colaboradores e representantes de mais de 20 usinas da região, em um dia repleto de conhecimento, inovação e troca de experiências.

Durante o encontro, acompanhamos de perto as mais recentes soluções da John Deere, como a colhedora CH950, o pulverizador 230M e as tecnologias de agricultura de precisão INC PRO e ExactApply — ferramentas que estão revolucionando o manejo da cana-de-açúcar, elevando os níveis de eficiência e produtividade no campo.

Além das demonstrações práticas, o evento contou com palestras técnicas sobre temas fundamentais para o futuro da mecanização e da gestão agrícola, entre eles: Gestão de Cana Georreferenciada, Inovação na Colheita de Cana e Tecnologia de Aplicação.

Tive a honra de palestrar sobre o projeto de integração com a API do Operations Center, desenvolvido pela Usina Alta Mogiana S/A, compartilhando as oportunidades, desafios e resultados dessa jornada. Foi uma experiência enriquecedora poder apresentar um trabalho que reflete o esforço conjunto de toda a equipe e que reforça o quanto a tecnologia e a integração de dados têm potencial para transformar a gestão agrícola.

Durante minha apresentação, também compartilhei algumas das melhores práticas de desenvolvimento que aplicamos no projeto — práticas que fazem da Usina Alta Mogiana S/A uma referência em inovação e uso de tecnologias avançadas no setor sucroenergético.

Aproveito este espaço para agradecer à John Deere e à Tracbel Agro pela impecável organização do evento e pela homenagem aos 42 anos da Usina Alta Mogiana S/A.

Meu agradecimento especial ao meu gerente Paulo Sérgio Santos, ao coordenador Wesley Bonini, e aos colegas Jefferson Ferracini, José Misael Alves e Cleyson Rodrigues Barbosa, que tiveram papel fundamental na execução e no sucesso deste projeto.

Também deixo meu reconhecimento aos amigos Alfredo Barbosa Neto, Felipe Fabro e Alexandre Kersten, parceiros essenciais nessa jornada.

O II Workshop de Tecnologia Canavieira foi muito mais do que um evento técnico — foi um momento de conexão, aprendizado e celebração da inovação, reforçando o compromisso da Tracbel Agro, da John Deere e da Usina Alta Mogiana S/A com o avanço tecnológico do setor canavieiro brasileiro.

Saio desse encontro ainda mais motivado a continuar contribuindo para um campo cada vez mais digital, integrado e sustentável.', '["assets/img/events/evento1.jpeg", "assets/img/events/evento2.jpeg", "assets/img/events/evento3.jpeg"]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (5, 'Frameworks mudam. Lógica não.', 'Publicação', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmSFrYVDJZO3z3ZPzqos-zWUshNO4XClUTlA&s', 'Todo ano surge um novo framework prometendo ser a solução definitiva.
Mais rápido. Mais moderno. Mais produtivo.

E muita gente entra na corrida para aprender o próximo da lista, Mas com o tempo, uma coisa fica clara:
frameworks vêm e vão — a lógica permanece.

Quem entende:

- estrutura de dados
- fluxo de execução
- boas práticas
- responsabilidade de cada camada
- como o sistema realmente funciona

consegue se adaptar a qualquer stack.

Quem aprende só como fazer funcionar dentro de um framework específico, sofre quando ele muda ou quando o projeto exige outra abordagem.

Frameworks são ferramentas.
Lógica é fundamento.

Invista tempo em entender o porquê, não só o como.
Isso é o que separa quem apenas escreve código de quem resolve problemas.

E você, prefere aprender frameworks ou dominar os fundamentos primeiro?', '[]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (6, 'Me diga como codas, que te direi quem és.', 'Publicação', 'https://assets-blog.hostgator.com.br/wp-content/uploads/2022/01/source-gcf3182850_1920.webp', 'Todo projeto de site ou aplicativo conta uma história. 
 E, muitas vezes, essa história começa (ou termina 😅) na estrutura de pastas e arquivos. 

 Código funciona? Ótimo. 
  Mas código bem organizado funciona melhor, cresce sem dor e não vira um campo minado daqui a 6 meses — principalmente quando outra pessoa (ou você mesmo no futuro) precisar mexer. 
 Aqui vão 3 pontos essenciais sobre organizar corretamente a estrutura do projeto: 

 📁 1. Organização não é frescura, é produtividade Uma estrutura clara economiza tempo. 

 Quando você sabe exatamente onde cada coisa mora, você: 

  Navega mais rápido no projeto.
 Evita arquivos duplicados. 
 Reduz aquela clássica pergunta: “onde foi que eu coloquei isso?” Tempo gasto organizando = tempo ganho codando.  

 🧠2. Código organizado comunica (até sem comentários) Uma boa estrutura fala por si só. 

 Mesmo sem ler uma linha de código, dá pra entender: 

 Onde estão componentes. 
 Onde ficam serviços, regras de negócio e estilos. 
 O que é reutilizável e o que é específico. 

 Isso facilita code review, onboarding de novos devs e evita aquele terror: “ninguém mais mexe nisso porque ninguém entende”. 

 🚀 3. Projeto organizado cresce sem virar caos 

 Todo projeto começa pequeno… até deixar de ser. 

 Quando a base já nasce organizada: Escalar é mais fácil. 
 Refatorar dói menos. 
 Bugs aparecem com menos frequência (e são mais fáceis de achar). 
 Projeto bagunçado até funciona — até o dia que precisa evoluir. 

 No fim das contas, não é só sobre código bonito. 
 É sobre pensar como engenheiro, não só como digitador de solução. 
 Porque sim…', '["https://ma.senac.br/wp-content/uploads/2016/09/49361450104366.jpg"]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (7, 'A Avalanche da Inteligência Artificial e a Transformação do Mercado de Trabalho', 'Inteligência Artificial', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgxR_pdTVS067z150ntM936swT6B5lA-CjM7wDPbAtT0qUpl0vkvFv-N0aXSTWrDzDMyLsf6bs4HVHb90ytz4W3hOvNj0P1xBCfOQV8nREdP3zgiW4dWZNrABNo2z0hGb2I_GRqIiZdcwTssGMnuaWTR6ehuvckyI5N8S8d7Qfk5gFSGmL1ssjZJv_aoN4/s16000/Create_an_ultra_realistic_cinematic_202605162012.jpeg', 'Nos últimos anos, a Inteligência Artificial deixou de ser apenas um assunto futurista para se tornar parte da rotina de empresas de praticamente todos os setores. O que antes parecia distante agora está presente em sistemas de atendimento, plataformas de vendas, automações internas, análise de dados, marketing, desenvolvimento de software, gestão agrícola, logística e até na forma como as empresas tomam decisões estratégicas. 

O problema é que essa transformação aconteceu rápido demais. 

Enquanto algumas empresas já operam com fluxos altamente automatizados, utilizando IA para ganhar velocidade, reduzir custos e aumentar produtividade, outras ainda tentam entender por onde começar em meio a uma enxurrada de informações, promessas milagrosas e ferramentas novas surgindo todos os dias. 

A verdade é que estamos vivendo uma avalanche tecnológica. 

E ela não está apenas mudando ferramentas. 
Ela está mudando profissões, processos, modelos de negócio e principalmente a forma como o trabalho acontece.  O Mercado Não Está Mais Apenas Testando IA 

Muitas pessoas ainda acreditam que Inteligência Artificial é algo experimental dentro das empresas. 

Mas a realidade já mudou. 

Hoje, empresas estão utilizando IA no dia a dia para: 

- automatizar atendimento ao cliente; 
- gerar campanhas de marketing; 
- analisar documentos; 
- resumir reuniões; 
- criar relatórios; 
- gerar código; 
- organizar fluxos internos; 
- acelerar produção de conteúdo; 
- prever vendas; 
- otimizar logística; 
- monitorar operações; 
- reduzir tarefas repetitivas; 
- integrar sistemas; 
- auxiliar equipes comerciais; 
- criar assistentes internos. 

Em muitos casos, a IA já não é mais vista como diferencial. 
Ela está começando a virar infraestrutura. 

Assim como internet e computação em nuvem deixaram de ser “inovação” e passaram a ser obrigatórias, a Inteligência Artificial caminha exatamente para o mesmo cenário.  Algumas Empresas Estão Muito na Frente 

Existe hoje uma diferença gigantesca entre empresas que entenderam o potencial da IA e empresas que apenas acompanham tendências superficiais. 

As organizações mais avançadas já possuem: 

- processos automatizados; 
- agentes de IA integrados ao negócio; 
- fluxos inteligentes; 
- análise de dados em tempo real; 
- atendimento parcialmente automatizado; 
- equipes utilizando IA diariamente; 
- cultura voltada para produtividade e otimização. 

Essas empresas não estão usando IA apenas para “brincar” ou gerar imagens. 
Elas estão usando IA para acelerar operação, reduzir desperdício de tempo e tomar decisões mais rápidas. 

Em muitos casos, pequenas equipes conseguem entregar resultados equivalentes ao trabalho de setores inteiros graças ao uso inteligente de automação e inteligência artificial. 

A produtividade aumentou. 
O tempo de execução caiu. 
E a velocidade virou vantagem competitiva.  Outras Empresas Ainda Estão Perdidas 

Ao mesmo tempo, existe uma enorme quantidade de empresas completamente perdidas. 

Isso acontece porque: 

- existem ferramentas demais; 
- todo dia surge uma nova IA; 
- muitas promessas são exageradas; 
- falta conhecimento técnico; 
- existe medo de substituição; 
- gestores não sabem onde aplicar; 
- equipes não foram preparadas; 
- há dificuldade em separar tendência de solução real. 

Muitas empresas entraram em um estado curioso: 

Elas sabem que precisam usar IA. 
Mas não sabem exatamente como. 

Então começam a testar ferramentas aleatórias sem estratégia. 

Usam IA para pequenas tarefas isoladas, mas sem integração real com os processos do negócio. 

Isso gera um cenário onde algumas empresas estão extremamente avançadas, enquanto outras apenas acumulam ferramentas sem conseguir gerar resultado prático.  O Maior Erro: Achar Que IA Resolve Tudo Sozinha 

Existe uma expectativa perigosa surgindo no mercado: 

A ideia de que Inteligência Artificial resolve qualquer problema automaticamente. 

Não resolve. 

A IA potencializa processos. 
Mas processos ruins continuam ruins. 

Empresas desorganizadas continuam desorganizadas mesmo usando ferramentas modernas. 

A diferença é que agora os erros acontecem mais rápido. 

Empresas que realmente conseguem extrair valor da IA normalmente possuem: 

- processos minimamente organizados; 
- objetivos claros; 
- estrutura tecnológica; 
- capacidade de adaptação; 
- profissionais preparados; 
- cultura de melhoria contínua. 

A Inteligência Artificial não substitui visão estratégica. 
Ela amplia capacidade operacional.  O Mercado de Trabalho Já Está Mudando 

A transformação causada pela IA não é algo para “os próximos anos”. 
Ela já começou. 

Algumas funções repetitivas estão sendo automatizadas. 
Muitas atividades operacionais estão sendo aceleradas. 
E profissionais que aprendem a trabalhar junto com IA estão aumentando drasticamente sua produtividade. 

O cenário atual não aponta necessariamente para o fim do trabalho humano. 
Mas aponta para uma mudança profunda na forma como profissionais entregam valor. 

Cada vez mais, empresas procuram pessoas capazes de: 

- resolver problemas; 
- aprender rápido; 
- utilizar ferramentas de IA; 
- automatizar tarefas; 
- integrar tecnologia ao negócio; 
- interpretar dados; 
- tomar decisões estratégicas; 
- adaptar processos. 

O profissional que ignora IA provavelmente terá mais dificuldade competitiva nos próximos anos. 

Da mesma forma que aconteceu com internet, redes sociais e computação em nuvem.  IA Não É Mais Tendência. É Mudança Estrutural. 

Muita gente ainda trata Inteligência Artificial como uma moda passageira. 

Mas tudo indica que estamos diante de uma transformação estrutural comparável ao surgimento da internet. 

A diferença é que agora a velocidade da mudança é muito maior. 

Ferramentas evoluem semanalmente. 
Modelos ficam mais inteligentes. 
Automatizações ficam mais acessíveis. 
E o custo para implementar soluções inteligentes vem diminuindo rapidamente. 

Empresas que conseguem aprender e adaptar rápido tendem a ganhar vantagem. 

As que demorarem demais podem enfrentar dificuldades para competir em produtividade, velocidade e inovação.  O Futuro Pertence a Quem Aprende Mais Rápido 

Talvez o ponto mais importante dessa transformação não seja a tecnologia em si. 

Mas a capacidade de adaptação. 

O mercado está entrando em uma fase onde aprender continuamente deixou de ser diferencial. 
Passou a ser necessidade. 

As empresas mais preparadas não são necessariamente as maiores. 
Muitas vezes são as que: 

- conseguem testar rápido; 
- aprendem rápido; 
- adaptam processos; 
- aceitam mudanças; 
- utilizam tecnologia com estratégia; 
- possuem mentalidade de evolução constante. 

A Inteligência Artificial não vai substituir empresas. 
Mas empresas que sabem usar IA provavelmente substituirão empresas que ignoram essa mudança. 

E isso talvez seja o movimento mais importante acontecendo no mercado atualmente.  Conclusão 

Estamos vivendo uma das maiores transformações tecnológicas das últimas décadas. 

A Inteligência Artificial já saiu do campo experimental e começou a ocupar espaço real dentro das operações das empresas. 

Enquanto algumas organizações avançam rapidamente utilizando IA para automatizar, acelerar e escalar processos, outras ainda tentam encontrar direção em meio ao excesso de informação. 

O desafio agora não é apenas acompanhar tendências. 

É entender como aplicar tecnologia de forma inteligente, estratégica e sustentável dentro da realidade de cada negócio. 

Porque no fim, a grande diferença não estará apenas em quem possui acesso às ferramentas. 

Mas em quem consegue transformar tecnologia em resultado real.', '[]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (8, 'Além do Chat: Como o NotebookLM Transforma Dados Isolados em um Cérebro Digital de Alta Produtividade', 'Inteligência Artificial', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjG2pG1uE2IzZDrtT90-dWvfp9Cee89kkdFtSmn-7KbuHd7DPDHs1W5ROJaxSA8xmMEY7kPuapSwtPMjA9TDeVwbtNdeoB51mOJX260lgYVRtaSmp06aqeOqvFElmHCpcm5HuOx7gOLwYH3YHFA_Alu39DU8KrMhLGiQyvXhm6asQ6h_fcezYq6C-Xec1E/s16000/A_hyper-realistic,_close-up_photograph_of_202605181635.jpeg', 'A Inteligência Artificial generativa tomou o world de assalto, mas a verdade nua e crua é que a maioria das pessoas e empresas parou na superfície. Usar a IA apenas como um “super buscador” ou um gerador de textos genéricos é o equivalente a comprar uma Ferrari para andar a 40 km/h na vaga de garagem. 

O mercado corporativo está vivendo uma transição rápida. De um lado, estão os profissionais que usam prompts básicos em chats convencionais e recebem respostas muitas vezes rasas ou desconectadas da realidade do seu negócio. Do outro, estão aqueles que entenderam que o verdadeiro poder da IA reside no contexto. 

Se você quer ver a IA trabalhar de forma profissional, prática e objetiva, você precisa ir além dos chats tradicionais. E o melhor ponto de partida para essa virada de chave atende pelo nome de NotebookLM.  O que é o NotebookLM e por que ele é diferente? 

Desenvolvido pelo Google, o NotebookLM é um assistente de pesquisa e notas personalizado. À primeira vista, ele pode parecer mais uma interface de chat, mas a sua arquitetura foi desenhada para resolver o maior problema das IAs atuais: as alucinações e a falta de contexto corporativo. 

Enquanto um chat convencional busca respostas no vasto e genérico banco de dados da internet, o NotebookLM cria uma “bolha de conhecimento” fechada. Ele só sabe o que você mandar ele saber. 

Você pode fazer o upload de: 

- arquivos em PDF e documentos de texto (manuais, relatórios, contratos); 
- links de sites e artigos específicos; 
- notas brutas, atas de reuniões ou transcrições de vídeos copiadas e coladas. 

A partir do momento em que esses dados são inseridos, o NotebookLM se torna um especialista focado única e exclusivamente no seu material.  Mas e a Segurança dos Dados? (A maior dúvida das empresas) 

Quando falamos em subir relatórios financeiros, dados de clientes ou estratégias internas para uma IA, a primeira reação de qualquer gestor ou profissional de TI é: “Isso é seguro? O Google vai usar os meus dados confidenciais para treinar a inteligência artificial pública deles?” 

A resposta curta e direta é: Não. 

O Google desenhou o NotebookLM com políticas rígidas de privacidade e governança corporativa: 

- Isolamento Total: Os documentos que você envia ficam restritos ao ambiente do seu “bloco de notas” específico. Nenhuma outra pessoa ou empresa tem acesso a eles, a menos que você decida compartilhar explicitamente o acesso. 
- Zero Treinamento com Dados Privados: O maior medo de vazamento é que a IA aprenda com os seus dados e acabe revelando-os para um concorrente em outra conversa. O regulamento oficial do Google estipula claramente que os dados enviados ao NotebookLM nunca são utilizados para treinar os seus modelos públicos de linguagem. O seu conhecimento permanece exclusivamente seu. 
- Segurança de Nível Empresarial: Para organizações que utilizam o Google Workspace (contas corporativas), o NotebookLM conta com camadas adicionais de proteção, enquadrando-se nas conformidades de privacidade de dados exigidas pelo mercado (Enterprise-grade privacy). 

Portanto, você pode trabalhar com as informações da sua empresa sabendo que existe uma barreira digital que impede que esses dados se tornem públicos ou alimentem a inteligência artificial de terceiros.  Os 3 Grandes Diferenciais do NotebookLM no Dia a Dia 

 1. Zero Alucinações (Rastreabilidade Total) 
O grande medo de usar IA para tomada de decisões é a famosa “alucinação” — quando a ferramenta inventa um dado com total convicção. No NotebookLM, cada resposta gerada vem acompanhada de citações diretas e numéricas das fontes que você enviou. Ao clicar na citação, ele te mostra exatamente o parágrafo do documento original de onde aquela informação foi extraída. 

 2. Cruzamento de Informações Complexas 
Imagine que você subiu o relatório financeiro do primeiro trimestre, o planejamento estratégico do ano e a pesquisa de satisfação do cliente. Você pode perguntar: “Com base nos dados de satisfação, quais investimentos listados no planejamento do trimestre devem ser priorizados?”. A IA fará uma varredura cruzada entre os arquivos em segundos, algo que um humano levaria dias para consolidar. 

 3. Criação de Guias e Resumos Automáticos 
Além de responder perguntas, a ferramenta conta com recursos nativos para transformar seus documentos brutos em guias de estudo, cronogramas, perguntas frequentes (FAQs) e até briefs de projetos com apenas um clique.  Como Aplicar o NotebookLM no Seu Negócio ou Carreira? 

As aplicações práticas são vastas, independentemente da sua área de atuação: 

- Recursos Humanos & Onboarding: Suba todos os manuais, políticas internas e códigos de conduta da empresa. Crie um “Guia do Novo Colaborador” interativo, onde ele mesmo pode tirar dúvidas sobre processos sem demandar tempo da equipe. 
- Vendas & Suporte Técnico: Alimente a ferramenta com as especificações técnicas dos seus produtos e o histórico de objeções dos clientes. Use-o como um assistente de consulta rápida para o time comercial fechar negócios com mais embasamento. 
- Marketing & Criação de Conteúdo: Reúna todas as pesquisas de persona, dados de mercado e transcrições de entrevistas com clientes. Peça para a IA identificar padrões de comportamento e sugerir pautas baseadas estritamente na dor real do seu público.  Conclusão: O Fim do Hype, o Início da Eficiência 

A avalanche de ferramentas de IA que vemos todos os dias cria uma ilusão de que tudo é complexo demais ou que exige habilidades avançadas de programação. O NotebookLM prova o contrário: a sofisticação está na simplicidade de centralizar o conhecimento que você já possui e extrair valor dele de forma inteligente. 

Se você quer que sua equipe produza mais, que suas decisões sejam baseadas em dados e não em palpites, o primeiro passo é parar de tratar a inteligência artificial como um brinquedo de perguntas e respostas. 

Crie a sua conta, suba os seus primeiros arquivos com total segurança e experimente a sensação de ter um especialista sênior que leu absolutamente tudo sobre o seu negócio, disponível 24 horas por dia.  Agora é sua vez 

Sabendo que os seus dados estão protegidos e não serão expostos, qual é o primeiro relatório ou manual da sua empresa que você vai transformar em um cérebro digital?', '[]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (9, 'Portal Theos: Construindo uma plataforma completa de ensino com arquitetura escalável.', 'EAD, Portal Completo, API, Integração, Vídeos, Treinamento', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiPdTBFLTO2ZtCdcwzGPJIl0qj-wIH2UcJihin_aIvo0znn7Hd6k2SLoJCc9u2lgF901jVTodxHMSvYsO7xOl5S5mSAYlvQGxzvDqCDFuNOaymsJ32LXyQGsROi8cB6A-D9V1JLn2dBggG_WQwzZTqKT7OsXby8RntCQWclPIm7lrtFMZGWhZvLwqIzUQ8/s1600/ChatGPT%20Image%204%20de%20ago.%20de%202026,%2010_39_40.png', '<p>Depois de muito planejamento, desenvolvimento e inúmeros desafios técnicos, finalmente posso apresentar o maior projeto que já desenvolvi: o <strong>Portal Theos</strong>.</p><p><br></p><p>Mais do que uma plataforma de cursos, o Portal Theos foi projetado para ser um ecossistema completo de ensino, oferecendo uma experiência fluida para alunos, professores e administradores, com foco em desempenho, segurança e escalabilidade.</p><p><br></p><h2>Acesse o projeto</h2><p><a href="https://portaltheos.com.br" target="_blank"><strong>https://portaltheos.com.br</strong></a></p><p><br></p><h2>Arquitetura pensada para crescer</h2><p>Desde o início, o objetivo era desenvolver uma solução que pudesse evoluir ao longo do tempo sem comprometer a organização do código.</p><p>Toda a aplicação foi construída sobre uma <strong>API robusta em C#</strong>, utilizando os princípios da <strong>Clean Architecture</strong>, separando responsabilidades em camadas bem definidas e facilitando manutenção, testes e evolução da plataforma.</p><p><br></p><p>Essa abordagem permite adicionar novos recursos com baixo acoplamento, mantendo o sistema organizado mesmo com o crescimento da aplicação.</p><p><br></p><h2>Um ecossistema completo</h2><p>A plataforma conta com diferentes ambientes integrados:</p><ul><li>Portal do Aluno</li><li>Portal do Professor</li><li>Landing Page</li><li>API central responsável por toda a regra de negócio</li></ul><p><br></p><p>Cada módulo foi desenvolvido para atender necessidades específicas, compartilhando a mesma base de serviços e garantindo consistência entre todas as funcionalidades.</p><p><br></p><h2>Integração de pagamentos</h2><p><br></p><p>Para automatizar todo o processo financeiro, a plataforma possui integração com a <strong>API do Asaas</strong>.</p><p><br></p><p>Entre os recursos implementados estão:</p><ul><li>geração automática de cobranças;</li><li>confirmação de pagamentos;</li><li>processamento via webhooks;</li><li>atualização automática do status dos pedidos;</li><li>sincronização entre pagamento e liberação de acesso aos cursos.</li></ul><p><br></p><p>Toda a comunicação foi desenvolvida visando confiabilidade e segurança nas transações.</p><p><br></p><h2>Armazenamento em nuvem</h2><p>Os arquivos da plataforma são armazenados utilizando o <strong>Cloudflare R2</strong>, garantindo alta disponibilidade e redução de custos com armazenamento.</p><p>As imagens são enviadas diretamente para o bucket, permitindo uma infraestrutura preparada para crescimento sem depender do servidor principal para servir arquivos estáticos.</p><p><br></p><h2>Streaming seguro de vídeo</h2><p>Um dos pontos mais importantes da plataforma é a proteção do conteúdo.</p><p>As videoaulas utilizam o <strong>Bunny.net</strong>, com autenticação para impedir acesso não autorizado aos vídeos.</p><p>Isso significa que os conteúdos ficam protegidos contra acesso direto, oferecendo uma camada extra de segurança para os produtores de conteúdo.</p><p><br></p><p>Entre as principais tecnologias empregadas neste projeto estão:</p><ul><li>C#</li><li>ASP.NET Core</li><li>Clean Architecture</li><li>REST API</li><li>Entity Framework Core</li><li>Asaas API</li><li>Cloudflare R2</li><li>Bunny.net</li><li>Autenticação JWT</li><li>Upload de arquivos</li><li>Webhooks</li><li>Controle de permissões</li><li>Banco de dados relacional MySql</li><li>Angular</li><li>Bootstrap</li><li>SCSS</li></ul><p><br></p><p>Cada tecnologia foi escolhida pensando em desempenho, organização e facilidade de manutenção.</p><p><br></p><h2>Muito além de uma plataforma de cursos</h2><p>O Portal Theos não é apenas um sistema para vender cursos.</p><p>Ele foi desenvolvido para ser uma base sólida que pode receber novos módulos, integrações e funcionalidades conforme a evolução do negócio.</p><p>Essa flexibilidade foi um dos principais objetivos durante toda a arquitetura do sistema.</p><p><br></p><h2>O resultado</h2><p><br></p><p>Este projeto representa centenas de horas de estudo, planejamento, modelagem e desenvolvimento.</p><p>Mais do que entregar funcionalidades, o foco foi construir uma aplicação preparada para escalar, utilizando boas práticas de engenharia de software, arquitetura limpa e integrações modernas com serviços em nuvem.</p><p>Ver essa plataforma funcionando em produção é a confirmação de que investir em arquitetura e qualidade de código faz toda a diferença.</p><p>Este é, sem dúvida, o projeto mais completo que já desenvolvi até hoje.</p><p>E esse é apenas o começo.</p>', '[]', 1, CURRENT_TIMESTAMP);
INSERT INTO posts (id, title, tag, img_header, content, images, published, created_at) VALUES (10, 'Iniciando uma nova jornada com n8n: automação inteligente e integrações sem limites.', 'N8N, IA, Inteligência Artificial', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEht7YDmA5vj2bCEiEaQV9RCprUjwPf9ClauIicKyYloOUj-jWZeKjsvChYy8FGlHdtAucdzY6RX3z8QQ72-rIv66uky4MdBy4IYlr-walaWLbz9qrjwJ2b7EOvX6nFnjmdjJjYMCMm6z739ZWSYAaI2UZGy2HkuqUYcnVNfUEGXo3D13xNLRFD_XVeYFe8/s1600/ChatGPT%20Image%204%20de%20ago.%20de%202026,%2013_47_03.png', '<p>A tecnologia evolui rapidamente, e acredito que um bom desenvolvedor nunca deve parar de aprender. Por isso, iniciei meus estudos avançados em <strong>n8n</strong>, uma das ferramentas de automação e integração que mais tem crescido no mercado.</p><p><br></p><p>Mais do que automatizar tarefas, o n8n permite criar fluxos inteligentes conectando APIs, bancos de dados, serviços em nuvem e, principalmente, aplicações de Inteligência Artificial.</p><p><br></p><h2>Por que escolhi o n8n?</h2><p>Nos últimos anos tenho desenvolvido sistemas completos utilizando <strong>C#</strong>, <strong>ASP.NET Core</strong>, <strong>Clean Architecture</strong> e integrações com diversas APIs. Agora, quero levar esses projetos para outro nível, criando automações que reduzam processos manuais e aumentem a produtividade.</p><p>O n8n oferece exatamente essa flexibilidade, permitindo construir fluxos complexos de forma visual, sem abrir mão da possibilidade de escrever código quando necessário.</p><p><br></p><h2>O que estou estudando</h2><p>Nesta nova etapa estou aprofundando conhecimentos em:</p><ul><li>Criação de workflows avançados;</li><li>Integração com APIs REST;</li><li>Webhooks;</li><li>Automações orientadas a eventos;</li><li>Processamento de dados;</li><li>Integração com bancos de dados;</li><li>IA Generativa (OpenAI e outros modelos);</li><li>Agentes de IA;</li><li>Automação de processos empresariais.</li></ul><p><br></p><p>O objetivo não é apenas aprender a ferramenta, mas entender como utilizá-la para desenvolver soluções robustas e escaláveis.</p><p><br></p><h2>O próximo passo</h2><p>Em breve pretendo compartilhar um projeto completo utilizando n8n, mostrando na prática como integrar diferentes serviços, automatizar processos e criar fluxos inteligentes que agreguem valor a aplicações reais.</p><p><br></p><p>Acredito que a combinação entre uma arquitetura sólida no backend e plataformas de automação como o n8n abre inúmeras possibilidades para desenvolver sistemas mais eficientes e inteligentes.</p><p><br></p><p>Este é apenas o começo dessa nova jornada. Em breve, teremos novidades e muitos projetos interessantes por aqui.</p><p><br></p><p><em>O aprendizado nunca termina. Cada nova tecnologia dominada amplia as possibilidades de criar soluções melhores.</em> 🚀</p>', '[]', 1, CURRENT_TIMESTAMP);

INSERT INTO projects (id, title, category, image_url, project_link, description, sort_order, created_at) VALUES (7, 'Portal do Cliente - Usina Alta Mogiana', 'filter-plataform', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhzlL7eIovZtnY0BpANGvatrtKrW9ivmGE_zBOBQhDkjfSK6-9zIZ8NuzlJ4D9ueyG3498DBDtnnOKmi-_i0mhBaM-890l2wXJz0U_d0ZRo2pHjBnsG2MvzpI8Nk6vxRDm9jvzqpS7nrO-ZFYeGj8JZk6_RsGcQh3SxocDvLHR7du27AV9td4FlC7yqH4A/s1600/ChatGPT%20Image%209%20de%20set.%20de%202026,%2007_27_21.png', 'https://clientes.altamogiana.com.br/', 'Neste projeto, atuei como desenvolvedor Frontend, sendo responsável pela definição e implementação da arquitetura da aplicação. Desenvolvi o template da plataforma, implementei os recursos de segurança e autenticação, além de atuar no desenvolvimento e integração de todos os módulos que compõem o portal.', 1, '2026-09-09 10:27:57');
INSERT INTO projects (id, title, category, image_url, project_link, description, sort_order, created_at) VALUES (6, 'Site Bioferth', 'filter-site', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjC2ZhYiGRELbaKOtZN5HXlg5E42QxKqexXvAADsOVYe4GqVHy2sd5f7EHlMO_HuJPjPI_O2U0ddvhiiFHS8fGli82fE58hUMEdJ8lS7ckzh_ytPSAT6SR1H_gIIADrt4OaA7AawaIhHd_rXmff53O2uJXhALv_vqXodC82kQeTv4SjGsduXIVbi41PKYI/s1600/ChatGPT%20Image%204%20de%20ago.%20de%202026,%2014_45_37.png', 'https://bioferth.com.br', 'Participei do desenvolvimento do site institucional da Bioferth, com o objetivo de criar uma plataforma moderna, responsiva e alinhada à identidade visual da empresa, proporcionando uma navegação intuitiva e uma apresentação clara de seus produtos, serviços e áreas de atuação.

O projeto foi desenvolvido utilizando tecnologias consolidadas do mercado, como PHP, HTML5, CSS e JavaScript, priorizando desempenho, compatibilidade entre navegadores e uma experiência de usuário de alta qualidade. Além disso, foi realizada a configuração e otimização da infraestrutura de hospedagem em uma VPS, garantindo maior estabilidade, segurança e performance para a aplicação.

Atuei na definição da arquitetura básica da infraestrutura da VPS, no planejamento da arquitetura da aplicação, no desenvolvimento do design da interface e na implementação completa do site institucional, participando desde a concepção da solução até sua publicação em ambiente de produção.', 2, '2026-08-04 17:46:23');
INSERT INTO projects (id, title, category, image_url, project_link, description, sort_order, created_at) VALUES (5, 'Portal Theos - EAD', 'filter-plataform', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiPdTBFLTO2ZtCdcwzGPJIl0qj-wIH2UcJihin_aIvo0znn7Hd6k2SLoJCc9u2lgF901jVTodxHMSvYsO7xOl5S5mSAYlvQGxzvDqCDFuNOaymsJ32LXyQGsROi8cB6A-D9V1JLn2dBggG_WQwzZTqKT7OsXby8RntCQWclPIm7lrtFMZGWhZvLwqIzUQ8/s1600/ChatGPT%20Image%204%20de%20ago.%20de%202026,%2010_39_40.png', 'https://joederblanca.com.br/service-details.html?post=9', 'Foi um projeto pensado desde o início para ser escalável, organizado e preparado para crescer. Toda a plataforma foi construída sobre uma API em C# utilizando Clean Architecture, responsável por atender diferentes aplicações:

✅ Portal do Aluno
✅ Portal do Professor
✅ Landing Page

Além da arquitetura, implementei integrações importantes para garantir desempenho e segurança:

💳 Integração completa com a API do Asaas para processamento de pagamentos e webhooks.
☁️ Armazenamento de imagens utilizando Cloudflare R2.
🎥 Streaming de videoaulas através do Bunny.net com autenticação, protegendo o conteúdo contra acessos não autorizados.', 3, '2026-08-04 17:41:46');
INSERT INTO projects (id, title, category, image_url, project_link, description, sort_order, created_at) VALUES (4, 'Site Aromatran', 'filter-site', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhKF6-n6V12LoiY2R4w_w9N7hktKmipxVo9jXCblUqeEoT8-bvaX6pTujB4CKHaSnlWhIi8Ge2unQr95jsFTzQKXQHLuthE4M1bBznppI45KTgnqNOZOmT412X-Nrllnbgg3DH6cDQ7uqvBHzqGb09791uPfve7I2_4vbS8rMN0m2QjqDdw4jIeFsgo2uc/s1600/ChatGPT%20Image%204%20de%20ago.%20de%202026,%2014_31_32.png', 'https://aromatran.com.br/', 'Participei do desenvolvimento do site institucional e da landing page do produto Aromatran, da empresa Bioferth. O projeto envolveu a utilização de tecnologias consolidadas do mercado, como PHP, HTML5, CSS e JavaScript, com foco em desempenho, responsividade e uma experiência de navegação intuitiva.

Além do desenvolvimento da aplicação, foi realizada a reestruturação completa do servidor VPS disponibilizado pelo cliente, incluindo sua configuração e otimização para garantir maior desempenho, estabilidade e segurança da hospedagem.

Atuei na definição da arquitetura básica da infraestrutura da VPS, bem como no planejamento da arquitetura da aplicação, design da interface e desenvolvimento completo da landing page, desde a implementação do frontend até sua publicação em produção.', 4, '2026-08-04 17:32:55');
INSERT INTO projects (id, title, category, image_url, project_link, description, sort_order, created_at) VALUES (3, 'Integração com GEC - Gap', 'filter-api', 'https://i.ytimg.com/vi/Id7KIWCivok/sddefault.jpg', NULL, 'Participei do projeto de integração entre o ERP da Usina Alta Mogiana S/A e a plataforma de gestão de empresas contratadas da GAP. A integração automatiza o controle de acesso de colaboradores terceirizados às dependências da usina, realizando, em tempo real, a validação de contratos, treinamentos obrigatórios e conformidade com as normas e requisitos estabelecidos para cada profissional.

Meu principal papel no projeto foi assumir a responsabilidade pela integridade e confiabilidade da integração, garantindo a continuidade e o correto funcionamento da comunicação entre os sistemas. Além disso, desenvolvi melhorias nos processos de validação e nas regras de negócio, aumentando a segurança, a eficiência e a confiabilidade das liberações de acesso.', 5, '2026-08-04 17:25:10');
INSERT INTO projects (id, title, category, image_url, project_link, description, sort_order, created_at) VALUES (2, 'Integração com Health & Safety - Bafômetros, Etilômetros', 'filter-api', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiVypcYSpyK3CCnDfzQ2jhyphenhyphenYBS_RmFs-2KIHKzCpcyqY7yRK7xZrXqokMu49RDjMsyEQQs4-llV8ZrpheaRrGu-Dpf1R3QgIVeLX_rfkrsaBDPzvLWkuF66SdM72YYkXLkytTYDEf0a8vBzKzXn_hd3cRewM1j9UOfShDpKUFQpT78cvgNxlCi1lQ2gm-Y/s320/000068-3CA17C77.jpg', NULL, 'Desenvolvi a integração entre a API da plataforma Health & Safety, responsável pelo gerenciamento de bafômetros e etilômetros, e a base de dados de colaboradores da empresa. A solução garante a sincronização automática e contínua dos cadastros de colaboradores, mantendo as informações sempre atualizadas na plataforma.

A integração também contempla a comunicação direta entre um serviço interno e os webhooks da API, permitindo o processamento automático de eventos e atualizações em tempo real.

Atuei como responsável técnico pelo projeto, realizando a definição da arquitetura da solução, o desenvolvimento de toda a implementação e a codificação da integração, desde a concepção até a entrega.
', 6, '2026-08-04 17:18:30');
INSERT INTO projects (id, title, category, image_url, project_link, description, sort_order, created_at) VALUES (1, 'Integração Operations Center John Deere', 'filter-api', 'https://www.deere.com.br/assets/images/region-4/products/precision-ag-technology/data-management/operations-center/operations_center_image_3_1024x576_large_6354f40cf50cd53877df42d6df76c0c1cd91db2c.jpg', NULL, 'Participei de todo o desenvolvimento da integração entre o ERP da Usina Alta Mogiana S/A e a plataforma Operations Center da John Deere. Essa integração possibilita a comunicação automática e em tempo real entre os tratores e as bases de dados da empresa, permitindo tanto o envio das informações necessárias para o uso de recursos de agricultura de precisão e piloto automático quanto a coleta dos dados operacionais dos equipamentos.

As informações obtidas são fundamentais para a gestão e o planejamento agrícola de toda a operação, proporcionando maior eficiência, confiabilidade e agilidade na tomada de decisões.

Atuei em todas as etapas do projeto, sendo responsável pela definição da arquitetura da integração, realização de testes de bancada, testes de campo com os tratores John Deere, treinamento dos usuários, desenvolvimento do frontend do ERP Web e implementação de parte das APIs responsáveis por toda a comunicação entre os sistemas.

O projeto teve início no final de 2022 e permanece em constante evolução, com novas funcionalidades e melhorias sendo desenvolvidas continuamente para atender às necessidades da operação.', 7, '2026-08-04 17:05:03');
