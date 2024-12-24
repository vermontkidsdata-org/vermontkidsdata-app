import OpenAI from "openai";
import { AnnotationDelta, FileCitationDeltaAnnotation } from "openai/resources/beta/threads/messages";
import { ChunkHandler, Footnote, } from '../src/ai-utils';

// jest.mock('openai', () => {
//   return {
//     files: {
//       retrieve: async (file_id: string) => {
//         console.log({ message: '*** openai.files.retrieve', file_id });
//       },
//     },
//   };
// });

describe('ai-utils', () => {
  describe('handleChunk', () => {
    const annotations: AnnotationDelta[] = [];
    const footnotes: Footnote[] = [];
    let chunkHandler: ChunkHandler;
    const openai = {
      files: {
        retrieve: async (file_id: string) => {
          console.log({ message: '*** openai.files.retrieve', file_id });
          return {
            id: file_id,
            filename: 'how_are_vermonts_young_children_2023.txt',
            purpose: 'my-purpose',
            bytes: 37,
          }
        },
      },
    } as unknown as OpenAI;

    beforeEach(() => {
      annotations.length = 0;
      footnotes.length = 0;
      chunkHandler = new ChunkHandler();
    });

    it('should handle chunk with no refs', async () => {
      const result = await chunkHandler.handleChunk({
        openai: {} as OpenAI,
        finished: false,
        chunk: 'chunk',
        annotations: [],
        footnotes: [],
        refnum: 0,
      });

      expect(result).toEqual({
        cleanChunk: 'chunk',
        refnum: 0,
      });

      // Only one chunk, so it's the same
      expect(result.cleanChunk).toBe(chunkHandler.getMessage());
    });

    it('should handle chunk with annotations', async () => {
      const result = await chunkHandler.handleChunk({
        openai,
        finished: false,
        chunk: 'chunk <<text>> rest-of-chunk',
        annotations: [{
          file_citation: {
            file_id: 'my-file-id',
          } as FileCitationDeltaAnnotation.FileCitation,
          index: 0,
          type: 'file_citation',
          text: '<<text>>',
        }],
        footnotes,
        refnum: 0,
      });

      console.log({ result, footnotes });
      expect(result).toEqual({
        cleanChunk: 'chunk [[1]](https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf) rest-of-chunk',
        refnum: 1,
      });
      expect(footnotes).toEqual([{
        refnum: 1,
        filename: 'how_are_vermonts_young_children_2023.txt',
        url: 'https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf',
        file_id: 'my-file-id',
      }]);
      // Only one chunk, so it's the same
      expect(result.cleanChunk).toBe(chunkHandler.getMessage());
    });

    // TODO Fix this test!
    // it('should not duplicate annotations', async () => {
    //   await chunkHandler.handleChunk({
    //     openai,
    //     finished: false,
    //     chunk: 'chunk <<text>> rest-of-chunk',
    //     annotations: [{
    //       file_citation: {
    //         file_id: 'my-file-id',
    //       } as FileCitationDeltaAnnotation.FileCitation,
    //       index: 0,
    //       type: 'file_citation',
    //       text: '<<text>>',
    //     }],
    //     footnotes,
    //     refnum: 0,
    //   });
    //   await chunkHandler.handleChunk({
    //     openai,
    //     finished: false,
    //     chunk: '<<text>>',
    //     annotations: [{
    //       file_citation: {
    //         file_id: 'my-file-id',
    //       } as FileCitationDeltaAnnotation.FileCitation,
    //       index: 0,
    //       type: 'file_citation',
    //       text: '<<text>>',
    //     }],
    //     footnotes,
    //     refnum: 0,
    //   });
    //   await chunkHandler.handleChunk({
    //     openai,
    //     finished: false,
    //     chunk: 'last chunk',
    //     annotations: [],
    //     footnotes,
    //     refnum: 0,
    //   });

    //   expect(chunkHandler.getMessage()).toBe('chunk [[1]](https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf) rest-of-chunklast chunk');
    // });
  });
});