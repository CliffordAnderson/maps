(: Reads page ranges from Internet Archive texts :)
(: Extracts geographic entities using the Alchemy API :)
(: Serializes disambiguated Entities to GeoJSON :)

xquery version "3.0";

declare function local:read-page($title as xs:string, $page as xs:integer) as item()?
{
  let $text := fn:string-join(
    let $doc := fn:doc(fn:concat("geojson/", $title))//OBJECT[$page]
    return 
    for $word in $doc//WORD/text()
    return ($word, " "))
  return fn:encode-for-uri($text)
};

declare function local:extract-page($doc as xs:string, $page as xs:integer, $api-key as xs:string) as item()*
{ 
let $page := local:read-page($doc, $page)
let $features := 
    let $entities :=
    http:send-request(
    <http:request method='post' href='http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities'>
       <http:body media-type='application/x-www-form-urlencoded' method='text'>apikey={$api-key}&amp;text={$page}</http:body>
    </http:request>
    )/results/entities
    for $entity in $entities/entity
    where $entity//geo
    return
    <feature type="object">
       <type>Feature</type>
       <properties type="object">
          {($entity/text)}
        </properties>
        <geometry type="object">
          <type>Point</type>
          <coordinates type="array">
            <coordinates>{fn:substring-after($entity/disambiguated/geo, " ")}</coordinates>
            <coordinates>{fn:substring-before($entity/disambiguated/geo, " ")}</coordinates>
          </coordinates>
      </geometry>
    </feature>
return $features
};

declare function local:extract-book($doc as xs:string, $pages as xs:integer, $api-key as xs:string) as item()?
{
   <json type="object">
    <type>FeatureCollection</type>
    <features type="array">
    {
      for $page in (1 to $pages)
      return local:extract-page($doc, $page, $api-key)
    }
    </features>
   </json>
};

let $api-key := "[Your Key Here]"
let $doc := "voyageofthetwosi00smit_djvu"
return json:serialize(local:extract-book($doc, 558, $api-key))