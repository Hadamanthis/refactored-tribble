# Aprendizados de Desenvolvimento de Jogos

Este arquivo registra conceitos importantes aprendidos durante o desenvolvimento. A ideia nao e documentar cada clique da Godot, mas guardar principios que vale treinar de novo em outros sistemas e projetos.

## 1. Separar regra, dado e visual

Um mesmo elemento do jogo pode ter partes diferentes:

- dado: informacao configuravel, como `IngredientData`, `RecipeData` e `CustomerData`;
- runtime: estado vivo da partida, como paciencia atual do cliente ou ingredientes dentro do caldeirao;
- visual: como esse estado aparece para o jogador.

Essa separacao evita que a interface vire dona da regra e facilita trocar arte, texto ou layout sem reescrever gameplay.

## 2. Composicao antes de sistemas globais

Antes de criar managers globais, autoloads ou sistemas grandes, preferimos cenas pequenas com responsabilidades claras.

Exemplos:

- `Cauldron` controla regra do caldeirao;
- `Customer` controla estado vivo do cliente;
- `CustomerView` desenha o cliente;
- `IngredientCard` representa uma carta clicavel;
- `IngredientHand` organiza varias cartas.

Isso reduz acoplamento e torna cada parte mais facil de testar manualmente.

## 3. Cena reutilizavel deve receber dados

Uma carta de ingrediente nao deve ter "Erva Verde" escrito fixo no script. Ela recebe um `IngredientData` e se atualiza.

Esse padrao permite adicionar novo conteudo criando ou editando Resources, nao duplicando codigo.

## 4. O emissor de um evento nao precisa saber quem reage

Sinais sao uma forma de aplicar o padrao Observer.

Uma carta emite `ingredient_selected`. Ela nao precisa conhecer o caldeirao, a receita ou a cena principal. Quem escuta decide o que fazer.

Isso mantem os componentes independentes.

## 5. Estado explicito evita bugs invisiveis

O caldeirao usa estados como `EMPTY`, `RECEIVING_INGREDIENTS` e `POTION_READY`.

Isso e melhor do que depender de varias flags soltas, porque cada acao pode validar claramente se e permitida naquele estado.

Quando existir uma lista, como ingredientes no caldeirao, ela pode ajudar a validar o estado, mas nao deve substituir o estado principal sem criterio.

## 6. Layout visual e comportamento sao responsabilidades diferentes

`IngredientHand` calcula onde as cartas ficam.

`IngredientCard` sabe como uma carta reage ao mouse.

Esse corte e importante: a mao nao precisa saber detalhes de hover, e a carta nao precisa saber quantas cartas existem.

## 7. Layout procedural e melhor que posicionamento manual repetido

Para uma mao de cartas, a posicao e rotacao devem depender da quantidade de cartas.

A ideia central:

- calcular o centro da mao;
- descobrir o deslocamento de cada carta em relacao ao centro;
- usar esse deslocamento para definir posicao, rotacao e profundidade visual.

Isso permite que a mao funcione com 3, 5 ou 10 cartas sem reposicionar tudo manualmente.

## 8. Separar hitbox de visual animado

Quando a carta subia no hover, a area clicavel tambem subia. O mouse saia da carta, disparava `mouse_exited`, e a carta piscava.

A solucao foi deixar o no interativo parado e mover apenas um filho visual, como `VisualRoot`.

Principio:

- hitbox/input deve ser estavel;
- visual pode animar livremente;
- o jogador sente movimento, mas o sistema de input nao fica instavel.

Esse padrao aparece em botoes, cartas, inimigos, pickups e menus animados.

## 9. Usar escala com cuidado em UI

Escala e boa para animacao momentanea, como hover ou feedback.

Para layout estavel, preferimos tamanho real, `custom_minimum_size`, anchors, containers e posicoes controladas.

Se a UI e desenhada gigante e reduzida com `scale`, texto, hitbox, pivots e filhos podem ficar dificeis de prever.

## 10. Placeholder bom ocupa o papel do asset final

Um placeholder nao precisa ser bonito, mas precisa testar o papel correto:

- icone deve ocupar o espaco que o icone final ocuparia;
- retrato deve ter proporcao parecida com o retrato final;
- fundo deve deixar areas livres para a gameplay;
- carta deve testar leitura, tamanho e interacao.

Placeholder ruim pode esconder problemas de layout.

## 11. Visual de jogo precisa de hierarquia

A tela nao deve parecer uma lista de controles. O jogador precisa perceber rapidamente:

- quem esta pedindo;
- onde esta o caldeirao;
- quais ingredientes pode escolher;
- qual foi o resultado da acao;
- qual e o estado da loja.

Arte, layout, tamanho e contraste devem guiar o olhar para o que importa.

## 12. Polimento deve confirmar a acao do jogador

Hover, brilho, som, shake, cor e animacao nao sao decoracao quando ajudam o jogador a entender que algo aconteceu.

Bom feedback responde perguntas como:

- cliquei?
- a acao funcionou?
- por que nao funcionou?
- qual elemento mudou?

Polimento bom reduz confusao.

## 13. Refatorar quando a dor aparece

Nem toda ideia precisa virar sistema imediatamente.

Mas quando uma responsabilidade comeca a se repetir, ficar confusa ou atrapalhar evolucao, e hora de extrair.

Foi o caso de:

- caldeirao virar componente proprio;
- cliente separar dado, runtime e visual;
- ingredientes virarem cartas;
- mao de cartas ganhar layout procedural.

## 14. Pensar no futuro sem implementar tudo agora

Podemos desenhar espaco para varios clientes, eventos e cartas extras sem implementar todos esses sistemas imediatamente.

Isso e diferente de overengineering:

- preparar layout para expansao e bom;
- criar managers sem necessidade ainda e cedo demais.

O projeto deve crescer em camadas jogaveis.

## 15. Sistemas pequenos ainda podem ser trabalhosos

Uma mao de cartas parece uma parte pequena da interface, mas envolve varios problemas reais:

- layout procedural;
- responsividade;
- ordem visual;
- hover;
- hitbox;
- legibilidade;
- textura, filtro e rotacao;
- assets com centro visual diferente do centro matematico.

Isso e normal em desenvolvimento de jogos. Muitas features simples para o jogador sao trabalhosas para o desenvolvedor porque precisam parecer naturais.

O cuidado importante e nao transformar dificuldade em sinal de fracasso. Quando uma parte parece grande demais, reduzimos o objetivo para um comportamento pequeno e verificavel.

## 16. Existem solucoes com custos diferentes

Para cartas, havia varios caminhos possiveis:

- botao simples com texto: rapido, mas com pouca cara de jogo;
- carta como imagem unica: muito simples visualmente, mas pouco flexivel para dados dinamicos;
- carta composta por frame, icone e texto: mais trabalhosa, mas reutilizavel e data-driven;
- sistema completo de cartas com arte unica, texto customizado e animacoes: melhor para jogo de cartas dedicado, mas caro cedo demais.

A melhor escolha depende do escopo. Neste projeto, a carta composta ensina bons principios sem exigir arte final para cada carta.

## 17. Centro visual nem sempre e centro matematico

Um `TextureRect` pode estar centralizado corretamente e ainda assim o desenho parecer torto.

Isso acontece quando o PNG tem:

- padding transparente desigual;
- objeto desenhado deslocado;
- silhueta assimetrica;
- sombra ou detalhes que pesam mais de um lado.

Antes de culpar o layout, vale verificar se o asset esta visualmente centralizado. Em jogos, muitas vezes ajustamos cada icone com um pequeno offset artistico.

## 18. Input em UI depende da area real dos Controls

Quando um objeto visual nao clica, a causa pode estar fora dele.

Possiveis causas:

- o `Button` nao cobre a area que o jogador esta clicando;
- um filho visual captura mouse sem precisar;
- um irmao grande esta por cima na ordem visual;
- um `Container` controla tamanho/posicao de forma diferente do esperado;
- `Mouse Filter` esta como `Stop` ou `Pass` onde deveria ser `Ignore`.

Um caso importante foi o `IngredientHandCenter`: ele estava com comportamento de mouse que propagava para o pai, mas isso nao ajudava o clique chegar ao irmao `CauldronButton`.

Principio:

- elementos clicaveis usam `Mouse Filter: Stop`;
- elementos puramente visuais usam `Ignore`;
- areas organizadoras ou decorativas geralmente tambem usam `Ignore`;
- em telas com objetos sobrepostos, sempre conferir a area real dos `Control`.

## 19. Cenas Godot podem juntar comportamento e visual

No inicio, separar `Cauldron` logico de `CauldronArea` visual ajudou a validar regra sem mexer na interface.

Com a evolucao do jogo, o caldeirao deixou de ser apenas regra e virou objeto interativo do mundo. Por isso, a direcao decidida e transformar o caldeirao em uma cena mais completa:

```text
Cauldron
├── visual
├── area clicavel
├── feedback visual
└── regra de ingredientes/mistura
```

Isso combina com a filosofia da Godot de usar cenas como unidades de composicao.

A regra continua importante:

- o visual nao deve decidir receita;
- a UI nao deve manipular listas internas diretamente;
- a cena do caldeirao pode expor metodos claros como `add_ingredient`, `mix`, `clear`, `can_mix`;
- efeitos visuais e clique podem viver junto do objeto, desde que nao confundam responsabilidade.

Essa mudanca deve ser feita quando o fluxo atual estiver validado, para evitar refatorar enquanto o comportamento basico ainda esta instavel.

## 20. Objeto clicavel precisa comunicar affordance

Quando trocamos botoes de UI por objetos do mundo, o jogador precisa perceber que aquilo pode ser clicado.

Um objeto clicavel pode comunicar isso com:

- hover;
- brilho;
- leve movimento idle;
- cursor ou mudanca visual ao passar o mouse;
- contorno/destaque;
- feedback imediato ao clicar.

Se um objeto aparece parado como parte do cenario, ele tende a parecer decoracao. Em jogos, interacao precisa ser visualmente convidativa.

O ideal e comecar simples:

- objeto aparece;
- objeto tem hover;
- objeto responde ao clique;
- depois ganha animacao/tween.

Isso evita polir uma interacao antes de validar se ela funciona no fluxo do jogo.
