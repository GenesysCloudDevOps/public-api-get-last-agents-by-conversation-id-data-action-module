resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "conversationId" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "userId" = {
                "items" = {
                    "title" = "Item 1",
                    "type" = "string"
                },
                "type" = "array"
            }
        },
        "title" = "List of last userIds",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/conversations/$${input.ConversationID}"
        
    }

    config_response {
        success_template = "{\"userId\" : $${userId}}}"
        translation_map = { 
			userId = "$.participants[?(@.purpose == 'agent')].userId"
		}
        translation_map_defaults = {       
			userId = "[\"Not Found\"]"
		}
    }
}