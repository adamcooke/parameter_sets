module ParameterSets
  class SchemaDSL

    def initialize
      @fields = []
    end

    attr_reader :fields

    def permit(field, *other_fields)
      if other_fields[0].is_a?(Symbol)
        permit(field)
        other_fields.each { |field| permit(field) }
      else
        if options = other_fields[0]
          @fields << {field => options}
        else
          @fields << field
        end
      end
    end

  end
end
