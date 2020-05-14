  myGIO() %>%
    addBase(base = "resourceMap",
            data = final,
            geoJson = final,
            mapping = list(dataKey = "geoid",
                           dataValue = "total_ili",
                           toolTip = "total_ili",
                           dataLabel = "county",
                           mapKey = "FIPSSTCO"),
            options = c(myGIO::setPolygonZoom(behavior = "click",zoomScale = 20),
                        nameFormat = 'text',
                        toolTipFormat = '.0f')
    ) %>%
    readGeoJSON("C:/Users/Morton/Documents/GitHub/fluTracker/app/maps/countyMap.geojson")
  