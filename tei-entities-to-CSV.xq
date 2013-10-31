(: Extracts entities from web-accessible texts using the Alchemy api :)
(: Serializes Disambiguated Entities to CSV :)
 
xquery version "3.0";
declare namespace csv = "http://basex.org/modules/csv";

let $apiKey := "[Your Key Here]"
let $url := "https://raw.github.com/iulibdcs/tei_text/master/vwwp_text/VAB7013.txt"
let $csv := 
  <csv>{
    let $entities :=
    http:send-request(
    <http:request method='post' href='http://access.alchemyapi.com/calls/url/URLGetRankedNamedEntities'>
       <http:body media-type='application/x-www-form-urlencoded' method='text'>apikey={$apiKey}&amp;url={$url}</http:body>
    </http:request>
    )/results/entities
    for $entity in $entities/entity
    where $entity//geo
    return 
      <record>
        {$entity/text}
        <lon>{fn:substring-before($entity/disambiguated/geo, " ")}</lon>
        <lat>{fn:substring-before($entity/disambiguated/geo, " ")}</lat>
      </record>
  }
  </csv>
return csv:serialize($csv)
