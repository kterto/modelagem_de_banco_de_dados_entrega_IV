# Rede Social de Receitas e Execuções “DIYou”

O projeto consiste em uma rede social voltada para cozinheiros, padeiros, cervejeiros
artesanais, marceneiros e entusiastas do “faça você mesmo” que desejam criar,
compartilhar e executar receitas passo a passo. Os usuários podem cadastrar receitas
completas com ingredientes, materiais, ferramentas e instruções detalhadas, além de
registrar suas execuções com fotos ou vídeos. O sistema também oferece um modo
de acompanhamento de execução, guiando o usuário por cada etapa da receita com
descrições e cronômetros integrados.

github https://github.com/kterto/modelagem_de_banco_de_dados_entrega_IV

## Setup 

O projeto conta com um Makefile e roda em um container do Docker. Então o principal requisito seria ter o Docker instalado na máquina e o `make` para conseguir rodar os comandos do `Makefile`. O setup mapeia o diretório `/scripts` para `/tmp/scripts/` dentro do container, isso facilita rodar os scripts diretamente dentro do container. Caso queira rodar manualmente o papel de cada script será definido mais adiante.

## Comandos

- up: 

  Rode `make up` para criar o container e começar a rodá-lo.

- down: 

  Rode `make down` para destruir o container e seus dados.

- run $SCRIPT:

  rode `make run script=NOME_DO_SCRIPT` para rodar o script localizado em `scripts/NOME_DO_SCRIPT.sql` dentro do container

## Scripts

- genertate_schema: 

  cria o schema do banco. Deve ser rodado primeiro, antes de rodar qualquer outro comando.
- seed: 

  para povoar as principais tabelas do banco com dados.
- test_queries: 

  executa consultas de teste para avaliar consistência do banco.
- data_modifications: 

  executa operações de UPDATE e DELETE no banco.