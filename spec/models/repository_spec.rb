require 'rails_helper' # class uses Hash#slice from ActiveSupport

RSpec.describe Repository do
  let(:attrs) {
    {
      id: 323,
      name: 'name'
    }
  }

  let(:persistence_class) {
    double('AR persistence class', {
      where: double(take: record),
      create: record
    })
  }

  let(:record) {
    double('AR record', {
      update_attributes: true,
    })
  }

  describe "when all the needed stuff is passed in" do
    let(:upserter) {
      Repository.new({
        persistence_class: persistence_class,
        attrs: attrs
      })
    }

    describe 'when the record is new' do
      let(:record) { nil }
      let(:new_record) { double('new record') }

      before do
        allow(persistence_class).to receive(:create).and_return(new_record)
      end

      it 'creates the record' do
        expect(persistence_class).to receive(:create).with(name: attrs[:name]).and_return(new_record)
        upserter.save
      end

      it 'returns the record' do
        expect(upserter.save).to eq(new_record)
      end

      describe "when no exception is raised" do
        it 'should be a success' do
          upserter.save
          expect(upserter.success?).to eq(true)
        end
      end

      describe "when an exception is raised" do
        before do
          allow(upserter).to receive(:warn)
          allow(persistence_class).to receive(:create).and_raise(ArgumentError.new('wha?'))
        end

        it 'should not be a success' do
          upserter.save
          expect(upserter.success?).to be(false)
        end
      end
    end

    describe 'when the record already can be found by id' do
      it 'finds the record in question' do
        expect(persistence_class).to receive(:where).with(id: attrs[:id]).and_return(double(take: record))
        upserter.save
      end

      it 'updates the record' do
        expect(record).to receive(:update_attributes).with(name: attrs[:name])
        upserter.save
      end

      it 'returns the record' do
        expect(upserter.save).to eq(record)
      end
    end
  end

  describe "when class is configured" do
    let(:upserter_class) {
      class RepositoryClass < Repository
        def find_keys
          [:program_id, :type]
        end
      end

      RepositoryClass
    }

    let(:upserter) { upserter_class.new(attrs: attrs, persistence_class: persistence_class) }

    let(:attrs) {
      {
        program_id: 324,
        type: 'that_thing',
        _value: 'it is!'
      }
    }

    it 'finds existing record via these keys' do
      expect(persistence_class).to receive(:where).with(program_id: 324, type: 'that_thing').and_return(double(take: record))
      upserter.save
    end
  end
end

