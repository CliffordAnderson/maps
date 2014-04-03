#Mapping Texts

##Experiments in Entity Extraction and Geocoding

This project explores the use of the [Alchemy API](http://www.alchemyapi.com/), a natural language processing service, to extract entities from public domain texts at the Internet Archive (and elsewhere) and to display those entities on maps using [GeoJSON](http://geojson.org/). Code samples have been written in XQuery and tested in [BaseX](http://basex.org/).

The sample book for this project is Egbert Bull Smith's [Voyage of the "Two Sisters": A Cabin Boy's Story](https://archive.org/stream/voyageofthetwosi00smit#page/n5/mode/2up) (1908). Specifically, the test code queries [this XML version of *Voyage of the "Two Sisters"*](https://ia700406.us.archive.org/3/items/voyageofthetwosi00smit/voyageofthetwosi00smit_djvu.xml). Its provisional geospatial "signature" may be viewed [here](https://github.com/CliffordAnderson/maps/blob/master/voyageofthetwosi00smit-whole.geojson).

This project was developed as part of a presentation with Lindsey Langsdon at [THATCamp Vanderbilt 2013](http://vanderbilt2013.thatcamp.org/).
