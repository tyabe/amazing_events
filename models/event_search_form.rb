class EventSearchForm
  include ActiveModel::Model

  attr_accessor :name, :date

  def initialize(query_params = {})
    query_params = {} unless query_params.is_a?(Hash)
    self.name = query_params['name']
    self.date = Date.parse("#{query_params['date(1i)']}-#{query_params['date(2i)']}-#{query_params['date(3i)']}") rescue Date.today
  end

  def search
    relation = Event.all
    relation = relation.where('name LIKE ?', "%#{name}%") if name.present?
    relation = relation.where('start_time >= ?', date.beginning_of_day) if date.present?
    relation
  end

end
