//
// Created by koncord on 02.01.16.
//

#ifndef OPENMW_DEDICATEDPLAYER_HPP
#define OPENMW_DEDICATEDPLAYER_HPP

#include <components/esm/custommarkerstate.hpp>
#include <components/esm/loadcrea.hpp>
#include <components/esm/loadnpc.hpp>
#include <components/openmw-mp/Base/BasePlayer.hpp>

#include "../mwclass/npc.hpp"

#include "../mwmechanics/aisequence.hpp"

#include "../mwworld/manualref.hpp"

#include <map>
#include <RakNetTypes.h>

namespace MWMechanics
{
    class Actor;
}

namespace mwmp
{
    struct DedicatedPlayer;

    class DedicatedPlayer : public BasePlayer
    {
        friend class PlayerList;

    public:

        void update(float dt);

        void move(float dt);
        void setBaseInfo();
        void setAnimFlags();
        void setEquipment();
        void setCell();
        void setShapeshift();

        void updateMarker();
        void removeMarker();
        void setMarkerState(bool state);

        void playAnimation();
        void playSpeech();

        ESM::NPC getNpcRecord();
        ESM::Creature getCreatureRecord();

        void createReference(ESM::NPC& npc, ESM::Creature& creature, bool reset);
        void updateReference(ESM::NPC& npc, ESM::Creature& creature);
        void deleteReference();

        MWWorld::Ptr getPtr();
        MWWorld::ManualRef* getRef();

        void setPtr(const MWWorld::Ptr& newPtr);

    private:

        DedicatedPlayer(RakNet::RakNetGUID guid);
        virtual ~DedicatedPlayer();

        int state;
        MWWorld::ManualRef* reference;

        MWWorld::Ptr ptr;

        ESM::CustomMarker marker;
        bool markerEnabled;
    };
}
#endif //OPENMW_DEDICATEDPLAYER_HPP
