# Teste-Reddit

Adições:
- Paginação, é carregado e armazenado o limite máximo de noticias (100), a table View carrega inicialmente 5, ao descer a scroll é carregado mais 5 e assim sucessivamente.
- Persistência local: salva as notícias  e os comentários no dispositivo, permitindo uma leitura offline.
- Compartilhamento: foi criado um Bar Button Item, que permite compartilhar a notícia, em qualquer rede social instalada no dispositivo.
- Auto Layout: ajuste no Title e Comments, para carregamento integral do texto, sem cortes, para isso foi usado UITableView.automaticDimension, Label -> lines = 0 e alguns ajustes nas constraints. 
- Adição do campo selftext: campo que carrega o descritivo da notícia apenas na view de detalhes.
