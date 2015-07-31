require 'spec_helper'
require 'json'
require 'json-schema'

describe JSON::Schema::Lite do
  let(:expected) do
    {
        type: :object,
        required: [:title, :body, :author, :tags, :related],
        properties: {
            title: { type: :string },
            body: { type: :string },
            vote: { type: :number },
            author: {
                type: :object,
                properties: {
                    name: { type: :string },
                    followers: {
                        type: :array,
                        items: {
                            type: :object,
                            properties: {
                                name: {
                                    type: :string
                                }
                            }
                        }
                    }
                }
            },
            tags: {
                type: :array,
                items: {
                    type: :string
                }
            },
            related: {
                type: :array,
                items: {
                    type: :object,
                    properties: {
                        title: { type: :string },
                        tags: {
                            type: :array,
                            items: {
                                type: :string
                            }
                        }
                    }
                }
            }
        }
    }
  end

  let(:json_obj) do
    {
        title: 'title',
        body: 'texttexttext',
        vote: 20,
        author: {
            name: 'author_name',
            followers: [
                { name: :jack },
                { name: :john }
            ]
        },
        tags: ['tag1', 'tag2'],
        related: [
            { title: 'related1', tags: ['tag1', 'tag3'] },
            { title: 'related2', tags: ['tag2', 'tag3'] }
        ]

    }
  end

  it 'has a version number' do
    expect(JSON::Schema::Lite::VERSION).not_to be nil
  end

  describe JSON::Schema::Lite::Object do
    let(:definition) do
      {
          type: :object,
          required: [:title, :body, :author, :tags, :related],
          properties: {
              title: :string,
              body: :string,
              vote: :number,
              author: {
                  type: :object,
                  properties: {
                      name: :string,
                      followers: [
                          type: :object,
                          properties: {
                              name: :string
                          }
                      ]
                  }
              },
              tags: [:string],
              related: [
                  type: :object,
                  properties: {
                      title: :string,
                      tags: [:string]
                  }
              ]
          }
      }
    end

    it 'returns json schema object' do
      expect(JSON::Schema::Lite.define(definition)).to eql expected
    end

    it 'returns valid json schema' do
      expect(JSON::Validator.validate JSON::Schema::Lite.generate(definition), json_obj, validate_schema: true, strict: true).to be true
    end
  end

  describe JSON::Schema::Lite::Block do
    let(:schema_obj) do
      JSON::Schema::Lite.define do
        string :title, required: true
        string :body, required: true
        number :vote
        object :author, required: true do
          string :name
          array :followers do
            string :name
          end
        end
        array :tags, :string, required: true
        array :related, required: true do
          string :title
          array :tags, :string
        end
      end
    end

    let(:json_schema) do
      JSON::Schema::Lite.generate do
        string :title, required: true
        string :body, required: true
        number :vote
        object :author, required: true do
          string :name
          array :followers do
            string :name
          end
        end
        array :tags, :string, required: true
        array :related, required: true do
          string :title
          array :tags, :string
        end
      end
    end

    it 'returns json schema object' do
      expect(schema_obj).to eql expected
    end

    it 'returns valid json schema' do
      expect(JSON::Validator.validate json_schema, json_obj, validate_schema: true, strict: true).to be true
    end
  end
end
