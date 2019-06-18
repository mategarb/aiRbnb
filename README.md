# aiRbnb
## RaukR 2019 project

### Aim of the work:

To present Airbnb data collection as a shiny application.

### To do:
+ a map showing regions of a city depending on price, distance to the city center etc. 
+ wordcloud for apartment descriptions, reviews etc.
+ basic statistic for a city or specific regions of a city

### Airbnb dataset
http://insideairbnb.com/get-the-data.html

### Data structure

Input is a table in .csv format.

+ id - just id                                        
+ listing_url                                 
+ scrape_id                              
+ last_scraped                               
+ name                                      
+ summary                                    
+ space                                       
+ description - apartment description (for wordcloud plot)                                
+ experiences_offered                       
+ neighborhood_overview - description of a district                  
+ notes                                     
+ transit                                    
+ access                                    
+ interaction                             
+ house_rules                               
+ thumbnail_url                             
+ medium_url                          
+ picture_url                                
+ xl_picture_url                            
+ host_id                                   
+ host_url                                   
+ host_name                                 
+ host_since                              
+ host_location                            
+ host_about                              
+ host_response_time                       
+ host_response_rate                       
+ host_acceptance_rate                      
+ host_is_superhost                        
+ host_thumbnail_url                        
+ host_picture_url                         
+ host_neighbourhood                       
+ host_listings_count                       
+ host_total_listings_count                 
+ host_verifications                    
+ host_has_profile_pic                   
+ host_identity_verified                    
+ street                           
+ neighbourhood - district name                        
+ neighbourhood_cleansed              
+ neighbourhood_group_cleansed             
+ city                                       
+ state                                       
+ zipcode                                     
+ market                                     
+ smart_location                              
+ country_code                               
+ country                                    
+ latitude - apartment position on map - ggmap()                                 
+ longitude - apartment position on map - ggmap()                             
+ is_location_exact                           
+ property_type                              
+ room_type                                  
+ accommodates                               
+ bathrooms                                   
+ bedrooms                                    
+ beds                                       
+ bed_type                                   
+ amenities - amenities included in the apartment (for wordcloud plot)                              
+ square_feet                                 
+ price                                  
+ weekly_price                               
+ monthly_price                               
+ security_deposit                            
+ cleaning_fee                               
+ guests_included                             
+ extra_people                               
+ minimum_nights                              
+ maximum_nights                              
+ minimum_minimum_nights                      
+ maximum_minimum_nights                      
+ minimum_maximum_nights                      
+ maximum_maximum_nights                      
+ minimum_nights_avg_ntm                      
+ maximum_nights_avg_ntm                   
+ calendar_updated                           
+ has_availability                          
+ availability_30                            
+ availability_60                             
+ availability_90                            
+ availability_365                            
+ calendar_last_scraped                     
+ number_of_reviews                         
+ number_of_reviews_ltm                     
+ first_review                              
+ last_review                              
+ review_scores_rating                  
+ review_scores_accuracy                     
+ review_scores_cleanliness                  
+ review_scores_checkin                  
+ review_scores_communication              
+ review_scores_location                  
+ review_scores_value                      
+ requires_license                           
+ license                                    
+ jurisdiction_names                         
+ instant_bookable                           
+ is_business_travel_ready                    
+ cancellation_policy                    
+ require_guest_profile_picture             
+ require_guest_phone_verification           
+ calculated_host_listings_count            
+ calculated_host_listings_count_entire_homes
+ calculated_host_listings_count_private_rooms
+ calculated_host_listings_count_shared_rooms
+ reviews_per_month

### Other analysis of Airbnb data

https://www.kaggle.com/djonafegnem/airbnb-data-analysis-in-r

http://rpubs.com/xyz8031/NewYorkCityAirbnbDataVisualizationWithR

https://towardsdatascience.com/airbnb-rental-listings-dataset-mining-f972ed08ddec


