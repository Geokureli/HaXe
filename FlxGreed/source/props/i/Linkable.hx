package props.i;

/** Able to link to `IReferables` */
interface Linkable
{
    /**
     * Used to retrieve all linked entity refs
     * @param   lookup  A function that retrieves entities by id
     */
    function initLinks(lookup:(id:String)->Null<Referable>):Void;
}