/*
    Author: Eamon Kelly, Enclude 27/2/2019
    Purpose: Use HTTP Post to get values from HealthAtlas and populate a picklist
    Called from: HealthAtlas component
    Adding the county, but it must be capitals, so take the last word in the county and capatilise it
    Tested in: ????
*/
public class HealthAtlasController 
{
	@AuraEnabled        
	public static List<String> getPickListValuesIntoList(String street, String county)
    {
    	List<String> pickListValuesList = new List<String>();
        String singleResponse;
        try
        {
            Http h=new Http(); 
            HttpRequest req = new HttpRequest();
            try{
				if (county != null){
					list<String> countyBits = county.split('[^a-zA-Z]');
					county = countyBits[countyBits.size() - 1].toUpperCase();
				} else county = '';          	
            } catch (exception e){county = '';}
            String endPoint = AppConfigSupport.HealthAtlasEndpoint + EncodingUtil.urlEncode(street, 'UTF-8') + '&geogArea=' + EncodingUtil.urlEncode(county, 'UTF-8') + '&maxAddr=40';
			system.debug (endPoint);             
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            //Send the request, andreturn a response 
            HttpResponse res = h.send(req); 
            String response = res.getBody(); 
            Integer statusCode = res.getStatusCode();
            if (statusCode == 200)
            {
            	map<String, Object> resp = (Map<String, Object>)JSON.deserializeUntyped(response);
            	Decimal numberOfAddresses = (Decimal)resp.get('no_items');
            	if (numberOfAddresses == 0)
            	{
            		singleResponse = 'Error: No Match Found';
            	}
            	else
            	{
		            list <Object> addresses = (List<Object>)resp.get('addresses');
		            if (addresses == null || addresses.size() == 0)
		            {
		            	singleResponse = 'Error: Too many matches';
		            }
		            for (Object oneAddress: addresses)
        		    {
                		map<String, Object> addressBits = (map<String, Object>)oneAddress;
                		String addressName = (String)addressBits.get ('name');
                		pickListValuesList.add(addressName);
        		    }
            	}
            }
            else
            {
            	singleResponse = 'Error code: ' + String.valueOf(statusCode);
            }
            
        }
        catch (Exception e)
        {
            singleResponse = 'Error: ' + e.getMessage();
        }

    	if (pickListValuesList.size() == 0)
    	{
    		pickListValuesList.add(String.valueOf(singleResponse));
    	}
    	return pickListValuesList;
	}

	@AuraEnabled        
	public static String getSingleAddress(String street)
    {
    	List<String> pickListValuesList = new List<String>();
        String singleResponse;
        try
        {
            Http h=new Http(); 
            HttpRequest req = new HttpRequest();
            String endPoint = AppConfigSupport.HealthAtlasEndpoint + EncodingUtil.urlEncode(street, 'UTF-8'); // may have to urlencode this
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            //Send the request, andreturn a response 
            HttpResponse res = h.send(req); 
            String response = res.getBody(); 
            Integer statusCode = res.getStatusCode();
            if (statusCode == 200)
            {
            	map<String, Object> resp = (Map<String, Object>)JSON.deserializeUntyped(response);
            	Decimal numberOfAddresses = (Decimal)resp.get('no_items');
            	if (numberOfAddresses == 0)
            	{
            		singleResponse = responseAsJSON ('No Match Found');
            	}
            	else
            	{
		            list <Object> addresses = (List<Object>)resp.get('addresses');
		            if (addresses == null || addresses.size() == 0)
		            {
		            	singleResponse = responseAsJSON ('Too many matches');
		            }
		            else
		            {
		            	singleResponse = JSON.serialize(addresses[0]);
		            }
            	}
            }
            else
            {
            	singleResponse = responseAsJSON('Error code: ' + String.valueOf(statusCode));
            }
            
        }
        catch (Exception e)
        {
            singleResponse = responseAsJSON(e.getMessage());
        }

     	return singleResponse;
	}
	
	static String responseAsJSON (String response)
	{
		JSONGenerator gen = JSON.createGenerator(true);
		gen.writeStartObject();
		gen.writeStringField ('response', response);
        gen.writeEndObject();
        return gen.getAsString();
	}
}