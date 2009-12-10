# Schemaless
module Schemaless
  def update_cells(params)
    self.class.transaction do
      params.keys.each do |key|
        self[key] = params[key]
      end
      save()
    end
  end
  
  def [](name)
    name = name.to_s
    result = cells.select{|cell| cell.name == name}
    if result.empty? then nil else result[0].value end
  end
  
  def []=(name, value)
    cell_class = self.class.const_get(self.class.name + "Cell")
    name = name.to_s
    cell = cells.find(:first, :conditions => {:name => name})
    unless cell
      cell = cell_class.new(:name => name)
      cells << cell
    end
    cell.value = value
    self.class.transaction do
      cell.save()
      save()
      value
    end
  end
  
  def keys
    cells.map &:name
  end
  
  # for Enumerable
  def each(&block)
    cells.map{|cell| [cell.name, cell.value]}.each(&block)
  end
  
  def self.included(mod)
    mod.instance_eval do
      cells = (name.underscore + "_cells").to_sym
      has_many cells
      alias_method :cells, cells
      #protected cells
      #protected :cells
      
      def mod.by_name(name)
        cells_table = (self.name.underscore + "_cells").to_sym
        self.find(:all, :joins => [cells_table],
          :conditions => {cells_table => {:name => name.to_s}})
      end
      
      def mod.by_name_and_value(name, value)
        cells_table = (self.name.underscore + "_cells").to_sym
        self.find(:all, :joins => [cells_table],
          :conditions => {cells_table => {:name => name.to_s, :value => value}})
      end
      
      def mod.by_names(names)
        cells_table = (self.name.underscore + "_cells")
        single = self.name.underscore
        query = names.each.map{|name|
          %{id IN (SELECT cells.#{single}_id FROM #{cells_table} AS cells WHERE
          cells.name = ?)}
        }.join(" AND ")
        self.find(:all, :conditions => [query] + names.map(&:to_s))
      end
      
      def mod.by_names_and_values(names_values)
        cells_table = (self.name.underscore + "_cells")
        single = self.name.underscore
        query = names_values.each.map{|name_value|
          %{id IN (SELECT cells.#{single}_id FROM #{cells_table} AS cells WHERE
          cells.name = ? AND cells.value = ?)}
        }.join(" AND ")
        args = names_values.map{|nv| [nv[0].to_s, nv[1]]}.flatten
        self.find(:all, :conditions => [query] + args)
      end
    end
  end
end

  