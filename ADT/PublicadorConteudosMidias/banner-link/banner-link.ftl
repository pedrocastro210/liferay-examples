<#list entries as entry>
	<#assign assetRenderer = entry.getAssetRenderer() />
	<#assign DDMFormFieldValuesMap = assetRenderer.getDDMFormValuesReader().getDDMFormValues().getDDMFormFieldValuesMap() />
	<#assign DDMFormFieldsReferencesMap = assetRenderer.article.DDMStructure.DDMForm.getDDMFormFieldsReferencesMap(true) />
	<#assign dlAppLocalServiceUtil = staticUtil["com.liferay.document.library.kernel.service.DLAppLocalServiceUtil"] />
	<#assign dlUtil = staticUtil["com.liferay.document.library.kernel.util.DLUtil"] />

	<#assign imageField = DDMFormFieldsReferencesMap['ImagemBanner'].name />
	<#assign image = DDMFormFieldValuesMap[imageField][0].getValue().getString(locale) />
	<#assign linkField = DDMFormFieldsReferencesMap['LinkBanner'].name />
	<#assign link = DDMFormFieldValuesMap[linkField][0].getValue().getString(locale) />
	
	<#if image?has_content>
		<#assign
            Img = image?eval
            ImgUuid = Img.uuid
            groupId = Img.groupId
            dlFile = dlAppLocalServiceUtil.getFileEntryByUuidAndGroupId(ImgUuid,groupId?number)
            imgUrl =  dlUtil.getPreviewURL(dlFile, dlFile.getFileVersion(),themeDisplay,'') 
        />
		
		<figure style="margin: 0; padding: 0; text-align: center;">
			<a href="${link}" target="_blank" style="display: inline-block; text-decoration: none;">
				<img src="${imgUrl}" alt="imagem de campanha" style="max-width: 50%; height: auto; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);" />
			</a>
		</figure>
	</#if>	
</#list>