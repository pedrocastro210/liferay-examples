# ADT para Publicador de Conteúdo e Mídias no Liferay 7.4

Este código utiliza a linguagem **FreeMarker** dentro de um **Application Display Template (ADT)** no Liferay 7.4. Ele é usado para exibir banners com imagens e links armazenados como conteúdo web e mídias na **Document Library**. Abaixo, explicamos cada parte do código.

## 1. Listando entradas de conteúdo

```freemarker
<#list entries as entry>
```

Inicia um loop que percorre uma lista chamada `entries`. Cada item (`entry`) representa uma entrada de conteúdo, como um **Web Content** (conteúdo web) ou similar.

## 2. Obtendo o *Asset Renderer* da entrada

```freemarker
<#assign assetRenderer = entry.getAssetRenderer() />
```

A variável `assetRenderer` é atribuída ao *Asset Renderer* da entrada atual. O *Asset Renderer* fornece acesso ao conteúdo e suas propriedades, permitindo manipulações como a extração de valores dinâmicos do formulário associado.

## 3. Extraindo valores do formulário dinâmico (*DDMForm*)

```freemarker
<#assign DDMFormFieldValuesMap = assetRenderer.getDDMFormValuesReader().getDDMFormValues().getDDMFormFieldValuesMap() />
<#assign DDMFormFieldsReferencesMap = assetRenderer.article.DDMStructure.DDMForm.getDDMFormFieldsReferencesMap(true) />
```

- **DDMFormFieldValuesMap**: Mapa contendo os valores dos campos do formulário dinâmico (*DDMForm*) da entrada de conteúdo.
- **DDMFormFieldsReferencesMap**: Mapa de referências dos campos do formulário (*DDMStructure*). O parâmetro `true` indica que ele está mapeando as referências dos campos.

## 4. Utilitários do Liferay para manipulação de documentos

```freemarker
<#assign dlAppLocalServiceUtil = staticUtil["com.liferay.document.library.kernel.service.DLAppLocalServiceUtil"] />
<#assign dlUtil = staticUtil["com.liferay.document.library.kernel.util.DLUtil"] />
```

Aqui, duas classes utilitárias do Liferay são atribuídas:
- **dlAppLocalServiceUtil**: Serviço que permite interagir com arquivos na Document Library, como recuperar arquivos por UUID e *groupId*.
- **dlUtil**: Utilitário que gera URLs de pré-visualização para arquivos armazenados na Document Library.

## 5. Acessando campos específicos do formulário dinâmico

```freemarker
<#assign imageField = DDMFormFieldsReferencesMap['ImagemBanner'].name />
<#assign image = DDMFormFieldValuesMap[imageField][0].getValue().getString(locale) />
<#assign linkField = DDMFormFieldsReferencesMap['LinkBanner'].name />
<#assign link = DDMFormFieldValuesMap[linkField][0].getValue().getString(locale) />
```

Aqui, acessamos dois campos específicos do formulário dinâmico:
- **imageField**: Nome do campo de imagem (`ImagemBanner`) a partir do mapa de referências.
- **image**: Valor do campo de imagem (pode ser uma URL ou uma referência à imagem), considerando o idioma (`locale`) atual.
- **linkField** e **link**: Nome e valor do campo de link (`LinkBanner`), que contém o link associado ao banner.

## 6. Verificando o conteúdo da imagem e processando a URL

```freemarker
<#if image?has_content>
    <#assign
        Img = image?eval
        ImgUuid = Img.uuid
        groupId = Img.groupId
        dlFile = dlAppLocalServiceUtil.getFileEntryByUuidAndGroupId(ImgUuid,groupId?number)
        imgUrl = dlUtil.getPreviewURL(dlFile, dlFile.getFileVersion(),themeDisplay,'') />
```

Se a imagem estiver presente, o código faz o seguinte:
- Avalia a string da imagem (`image?eval`) e a transforma em um objeto (`Img`).
- Extrai o UUID e o *groupId* da imagem para buscar o arquivo na Document Library.
- Usa o `dlAppLocalServiceUtil` para obter o arquivo baseado no UUID e *groupId*.
- Gera a URL de pré-visualização da imagem usando o `dlUtil`.

## 7. Gerando o HTML da imagem com o link

```freemarker
<figure>
    <a href="${link}" target="_blank">
        <img src="${imgUrl}" alt="imagem de campanha"/>
    </a>
</figure>
```

Se a imagem existir, o código gera um bloco HTML que exibe a imagem (`<img>`) e a coloca dentro de um link (`<a>`). A URL da imagem é gerada dinamicamente, e o link (`href`) é obtido do campo `LinkBanner`.

## Conclusão

Este ADT é uma maneira eficiente de exibir banners com imagens e links no Liferay 7.4. Ele recupera dados de formulários dinâmicos, encontra imagens na Document Library e gera visualizações HTML apropriadas, tornando o conteúdo mais acessível e interativo.

---