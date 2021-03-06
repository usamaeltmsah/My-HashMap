require_relative 'p04_linked_list'

class HashMap
  include Enumerable
  attr_accessor :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    resize! if self.count >= num_buckets
    if include?(key)
      bucket(key).update(key, val)
    else
      bucket(key).append(key, val)
      self.count += 1
    end
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    rem = bucket(key).remove(key)
    self.count -= 1 if rem
    rem
  end

  def each
    @store.each do |bucket|
      bucket.each do |l|
        yield [l.key, l.val]
      end
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :inspect, :to_s
  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    prev_store = @store
    @store = Array.new(2 * num_buckets) { LinkedList.new }
    self.count = 0

    prev_store.each do |bucket|
      bucket.each do |l|
        set(l.key, l.val)
      end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
    ind = key.hash % num_buckets
    @store[ind]
  end
end
