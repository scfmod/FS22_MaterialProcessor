local outputDirectory = g_currentModDirectory .. 'docs/schema/'
---@type string | nil
local overrideFileOpen
local mod = g_modManager:getModByName(g_currentModName)

if mod ~= nil and not mod.isDirectory then
    outputDirectory = g_modSettingsDirectory
end

SpecializationManager.postInitSpecializations = Utils.overwrittenFunction(
    SpecializationManager.postInitSpecializations,

    ---@param self SpecializationManager
    function(self)
        if self.typeName == 'vehicle' then
            ---@type XMLSchema
            local schema = Vehicle.xmlSchema

            overrideFileOpen = 'materialProcessor.xsd'
            schema:generateSchema()

            overrideFileOpen = 'materialProcessor.html'
            schema:generateHTML()

            ---@diagnostic disable-next-line: undefined-global
            requestExit()
        end
    end
)


io.open = Utils.overwrittenFunction(io.open,
    ---@param filename string
    ---@param superFunc fun(filename: string, options: any): any
    ---@param options any
    ---@return table
    function(filename, superFunc, options)
        if overrideFileOpen ~= nil then
            filename = outputDirectory .. overrideFileOpen
        end

        return superFunc(filename, options)
    end
)
