module docii.parse.checker;

import docii.parse.docs;
import docii.log : logger, Color;

/++
 +
 +/
public void checkDocs(Doc[string] docs)
{
    foreach (name, doc; docs)
    {
        if (FunctionDoc fdoc = cast(FunctionDoc) doc)
        {
            if (!fdoc.hasInfo)
                logger.print("❌" ~ Color.WHITE ~ " info section missing for declaration " ~ Color.BOLD_RED ~ name);

            if (!fdoc.hasParams)
                logger.print("❌" ~ Color.WHITE ~ " params section missing for declaration " ~ Color.BOLD_RED ~ name);

            if (!fdoc.hasReturns)
                logger.print("❌" ~ Color.WHITE ~ " returns section missing for declaration " ~ Color.BOLD_RED ~ name);

            if (!fdoc.hasThrows)
                logger.print("❌" ~ Color.WHITE ~ " throws section missing for declaration " ~ Color.BOLD_RED ~ name);
        }
        else
        {
            if (!doc.hasInfo)
                logger.print("❌" ~ Color.WHITE ~ " info section missing for declaration " ~ Color.BOLD_RED ~ name);
        }
    }
}