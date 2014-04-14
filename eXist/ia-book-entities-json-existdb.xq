(: Reads page ranges from Internet Archive texts :)
(: Extracts geographic entities using the Alchemy API :)
(: Serializes disambiguated entities to GeoJSON :)

xquery version "3.0";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace json="http://www.json.org";

(: Switch to JSON serialization :)
declare option output:method "json";
declare option output:media-type "text/javascript";

declare function local:read-page($title as xs:string, $page as xs:integer) as item()?
{
  let $doc := fn:doc(fn:concat("/db/geojson/", $title))//OBJECT[$page]
  let $text := fn:string-join($doc//WORD/text(), " ")
  return fn:encode-for-uri($text)
};

declare function local:extract-page($doc as xs:string, $page as xs:integer, $api-key as xs:string) as item()*
{ 
    let $page := local:read-page($doc, $page)
    let $entities := httpclient:post(xs:anyURI('http://access.alchemyapi.com/calls/text/TextGetRankedNamedEntities'), 'apikey=' || $api-key || '&amp;text=' || $page, fn:false(), ())//results/entities
    for $entity in $entities/entity
    where $entity//geo
    return
    <json:value>
       <type>Feature</type>
       <properties>
          {($entity/text)}
        </properties>
        <geometry type="Point">
            <coordinates>{fn:substring-after($entity/disambiguated/geo, " ")}</coordinates>
            <coordinates>{fn:substring-before($entity/disambiguated/geo, " ")}</coordinates>
      </geometry>
    </json:value>
};

declare function local:extract-book($doc as xs:string, $pages as xs:integer, $api-key as xs:string) as item()?
{
   <json type="FeatureCollection">
    <features>
    {
      for $page in (1 to $pages)
      return local:extract-page($doc, $page, $api-key)
    }
    </features>
   </json>
};

let $api-key := "[YOUR KEY HERE]"
let $doc := "voyageofthetwosi00smit_djvu.xml"
return local:extract-book($doc, 50, $api-key)