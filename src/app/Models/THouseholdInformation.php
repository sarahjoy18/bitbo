<?php

/**
 * Created by Reliese Model.
 * Date: Fri, 02 Aug 2019 07:12:15 +0000.
 */

namespace App\Models;

use Reliese\Database\Eloquent\Model as Eloquent;

/**
 * Class THouseholdInformation
 * 
 * @property int $HOUSEHOLD_ID
 * @property string $HOME_OWNERSHIP
 * @property string $PERSON_STAYING_IN_HOUSEHOLD
 * @property string $HOME_MATERIALS
 * @property string $STREET_ADDRESS
 * @property string $BARANGAY_ZONE_ADDRESS
 * @property int $BARANGAY_ID
 * @property int $NUMBER_OF_ROOMS
 * @property int $TOILET_HOME
 * @property int $PLAY_AREA_HOME
 * @property int $BEDROOM_HOME
 * @property int $DINING_ROOM_HOME
 * @property int $SALA_HOME
 * @property int $KITCHEN_HOME
 * @property int $WATER_UTILITIES
 * @property int $ELECTRICITY_UTILITIES
 * @property int $AIRCON_UTILITIES
 * @property int $PHONE_UTILITIES
 * @property int $COMPUTER_UTILITIES
 * @property int $INTERNET_UTILITIES
 * @property int $TV_UTILITIES
 * @property int $CD_PLAYER_UTILITIES
 * @property int $RADIO_UTILITIES
 * @property int $COMICS_ENTERTAINMENT
 * @property int $NEWS_PAPER_ENTERTAINMENT
 * @property int $PETS_ENTERTAINMENT
 * @property int $BOOKS_ENTERTAINMENT
 * @property int $STORY_BOOKS_ENTERTAINMENT
 * @property int $TOYS_ENTERTAINMENT
 * @property int $BOARD_GAMES_ENTERTAINMENT
 * @property int $PUZZLES_ENTERTAINMENT
 * @property \Carbon\Carbon $CREATED_AT
 * @property \Carbon\Carbon $UPDATED_AT
 * @property int $ACTIVE_FLAG
 * 
 * @property \App\Models\RBarangayInformation $r_barangay_information
 * @property \Illuminate\Database\Eloquent\Collection $t_resident_basic_infos
 *
 * @package App\Models
 */
class THouseholdInformation extends Eloquent
{
	protected $table = 't_household_information';
	protected $primaryKey = 'HOUSEHOLD_ID';
	public $timestamps = false;

	protected $casts = [
		'BARANGAY_ID' => 'int',
		'NUMBER_OF_ROOMS' => 'int',
		'TOILET_HOME' => 'int',
		'PLAY_AREA_HOME' => 'int',
		'BEDROOM_HOME' => 'int',
		'DINING_ROOM_HOME' => 'int',
		'SALA_HOME' => 'int',
		'KITCHEN_HOME' => 'int',
		'WATER_UTILITIES' => 'int',
		'ELECTRICITY_UTILITIES' => 'int',
		'AIRCON_UTILITIES' => 'int',
		'PHONE_UTILITIES' => 'int',
		'COMPUTER_UTILITIES' => 'int',
		'INTERNET_UTILITIES' => 'int',
		'TV_UTILITIES' => 'int',
		'CD_PLAYER_UTILITIES' => 'int',
		'RADIO_UTILITIES' => 'int',
		'COMICS_ENTERTAINMENT' => 'int',
		'NEWS_PAPER_ENTERTAINMENT' => 'int',
		'PETS_ENTERTAINMENT' => 'int',
		'BOOKS_ENTERTAINMENT' => 'int',
		'STORY_BOOKS_ENTERTAINMENT' => 'int',
		'TOYS_ENTERTAINMENT' => 'int',
		'BOARD_GAMES_ENTERTAINMENT' => 'int',
		'PUZZLES_ENTERTAINMENT' => 'int',
		'ACTIVE_FLAG' => 'int'
	];

	protected $dates = [
		'CREATED_AT',
		'UPDATED_AT'
	];

	protected $fillable = [
		'HOME_OWNERSHIP',
		'PERSON_STAYING_IN_HOUSEHOLD',
		'HOME_MATERIALS',
		'STREET_ADDRESS',
		'BARANGAY_ZONE_ADDRESS',
		'BARANGAY_ID',
		'NUMBER_OF_ROOMS',
		'TOILET_HOME',
		'PLAY_AREA_HOME',
		'BEDROOM_HOME',
		'DINING_ROOM_HOME',
		'SALA_HOME',
		'KITCHEN_HOME',
		'WATER_UTILITIES',
		'ELECTRICITY_UTILITIES',
		'AIRCON_UTILITIES',
		'PHONE_UTILITIES',
		'COMPUTER_UTILITIES',
		'INTERNET_UTILITIES',
		'TV_UTILITIES',
		'CD_PLAYER_UTILITIES',
		'RADIO_UTILITIES',
		'COMICS_ENTERTAINMENT',
		'NEWS_PAPER_ENTERTAINMENT',
		'PETS_ENTERTAINMENT',
		'BOOKS_ENTERTAINMENT',
		'STORY_BOOKS_ENTERTAINMENT',
		'TOYS_ENTERTAINMENT',
		'BOARD_GAMES_ENTERTAINMENT',
		'PUZZLES_ENTERTAINMENT',
		'CREATED_AT',
		'UPDATED_AT',
		'ACTIVE_FLAG'
	];

	public function r_barangay_information()
	{
		return $this->belongsTo(\App\Models\RBarangayInformation::class, 'BARANGAY_ID');
	}

	public function t_resident_basic_infos()
	{
		return $this->hasMany(\App\Models\TResidentBasicInfo::class, 'HOUSEHOLD_ID');
	}
}
