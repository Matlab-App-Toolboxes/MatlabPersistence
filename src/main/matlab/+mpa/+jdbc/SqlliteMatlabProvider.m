classdef SqlliteMatlabProvider < mpa.core.AbstractProvider
    
    properties (Access = private)
        jprepareStatement
    end
    
    methods
        
        function createDefintion(obj)
            % if database doesnot exist, then create connection takes care
            % of creating for the very first time
            obj.createConnection();
        end
        
        function createEntites(obj, entitySchemaMap)
            valueSet = entitySchemaMap.values;
            schemas = [valueSet{:}];
            
            obj.createConnection();
            for schema = schemas
                query = obj.createTableQuery(schema);
                try
                    statement = obj.jConnection.createStatement();
                    statement.execute(query);
                    obj.close(statement);
                catch exception
                    disp(exception.getReport());
                    obj.close(statement);
                end
            end
            obj.close(jConnection);
            
        end
        
        function tableManager = createEntityManager(obj)
            obj.close(jprepareStatement);
            obj.createConnection();
            jprepareStatement = @(query) obj.jConnection.prepareStatement(query);
            tableManager = mpa.jdbc.SqlliteTableManager(jStatement);
        end
    end
    
    methods (Access = private)

        function close(obj, prop)
            if ~ isempty(obj.(prop)) && ~ obj.(prop).isClosed()
                obj.(prop).close();
                obj.(prop) = [];
            end
            obj.(prop) = [];
        end    
        
        function createConnection(obj)
            
            if isempty(obj.jConnection)
                mpa.util.loadJavaClass.forName('org.sqlite.JDBC');
                obj.jConnection = java.sql.DriverManager.DriverManager.getConnection(obj.localPath);
            end
        end
        
        function query = createTableQuery(~, entitySchema)
            
            queryBuffer = ['CREATE TABLE IF NOT EXISTS ' entitySchema.name '( '...
                entitySchema.id.name ' ' getDataType(entitySchema.id.attributeType) ' PRIMARY KEY'];
            basics = entitySchema.basics;
            columns = {basics.name};
            types = {basics.name};
            
            for i = 1 : numel(columns)
                queryBuffer = strcat(queryBuffer, ', ', columns{i}, ' ', getDataType(types{i}));
            end
            query = strcat(queryBuffer, ' );');
        end
    end
    
end

