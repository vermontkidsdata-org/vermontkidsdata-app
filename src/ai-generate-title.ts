import { Completion, getCompletionPK } from "./db-utils";
import { StepFunctionInputOutput, makePowerTools, prepareStepFunction } from "./lambda-utils";
import { connectOpenAI, getOpenAI } from "./ai-utils";

const pt = makePowerTools({ prefix: 'ai-generate-title' });

export const lambdaHandler = async (event: StepFunctionInputOutput): Promise<StepFunctionInputOutput> => {
  pt.logger.info({ message: 'Generating title for conversation', event });

  // Only generate titles for the first message in a conversation (sortKey = 0)
  if (event.sortKey !== 0) {
    pt.logger.info({ message: 'Not the first message in conversation, skipping title generation', sortKey: event.sortKey });
    return event;
  }

  // Get the completion record
  const pk = getCompletionPK(event.id, event.sortKey);
  const item = await Completion.get(pk);
  
  if (!item?.Item) {
    pt.logger.error({ message: 'Completion not found', id: event.id, sortKey: event.sortKey });
    return event;
  }

  pt.logger.info({ message: 'Fetched completion record', item: item.Item });
  
  // If the completion already has a title, skip title generation
  if (item.Item.title) {
    pt.logger.info({ message: 'Completion already has a title', title: item.Item.title });
    return event;
  }

  // Get the query and response message
  const query = item.Item.query;
  const message = item.Item.message;

  if (!query || !message) {
    pt.logger.error({ message: 'Missing query or message for title generation', userQuery: query, responseMessage: item.Item.message });
    return event;
  }

  try {
    // Connect to OpenAI
    await connectOpenAI();

    // Generate a title using OpenAI
    const response = await getOpenAI().chat.completions.create({
      model: "gpt-4o",
      messages: [
        {
          role: "system",
          content: "You are a helpful assistant that generates short, descriptive titles for conversations. The title should summarize the main topic or question being discussed."
        },
        {
          role: "user",
          content: `Generate a short, concise title (maximum 50 characters) for this conversation:\n\nUser: ${query}\n\nAssistant: ${message.substring(0, 500)}...`
        }
      ],
      max_tokens: 30,
      temperature: 0.7,
    });

    const title = response.choices[0]?.message?.content?.trim();
    
    if (title) {
      pt.logger.info({ message: 'Generated title', title });
      
      // Update the completion with the generated title
      await Completion.update({
        ...pk,
        title,
      });
      
      return {
        ...event,
      };
    } else {
      pt.logger.error({ message: 'Failed to generate title', response });
      return event;
    }
  } catch (error) {
    pt.logger.error({ message: 'Error generating title', error });
    return event;
  }
};

export const handler = prepareStepFunction(lambdaHandler);