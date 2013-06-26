# monkey patch for https://github.com/mixonic/ranked-model/issues/41
module RankedModel
  class Ranker
    class Mapper
      def finder
        @finder ||= begin
          _finder = instance_class
          columns = [instance_class.arel_table[:id], instance_class.arel_table[ranker.column]]
          if ranker.scope
            _finder = _finder.send ranker.scope
          end
          case ranker.with_same
            when Symbol
               columns << ranker.with_same
              _finder = _finder.where \
                instance_class.arel_table[ranker.with_same].eq(instance.attributes["#{ranker.with_same}"])
            when Array
              columns.push *ranker.with_same
              _finder = _finder.where(
                ranker.with_same[1..-1].inject(
                  instance_class.arel_table[ranker.with_same.first].eq(
                    instance.attributes["#{ranker.with_same.first}"]
                  )
                ) {|scoper, attr|
                  scoper.and(
                    instance_class.arel_table[attr].eq(
                      instance.attributes["#{attr}"]
                    )
                  )
                }
              )
          end
          if !new_record?
            _finder = _finder.where \
              instance_class.arel_table[instance_class.primary_key].not_eq(instance.id)
          end
          # _finder.order(instance_class.arel_table[ranker.column].asc).select([instance_class.arel_table[instance_class.primary_key], instance_class.arel_table[ranker.column]])
          _finder.order(instance_class.arel_table[ranker.column].asc).select(columns)
        end
      end
    end
  end
end
